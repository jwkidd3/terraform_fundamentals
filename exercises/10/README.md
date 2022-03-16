# Exercise #10: Backends and Remote State

By default, Terraform stores state locally, but as we noticed, there's a problem with this:

What if you work on a team where different people will run Terraform at different times from different places? This
means you need to share your state file. Some have used encrypted local files in source control, but this is not maintainable or scalable. So, enter the idea of central remote options for storing
your state files.

Since this course is about Terraform acting on AWS specifically, let's look at a relevant option that Terraform provides: S3.

Storing Terraform state in an S3 bucket is as simple as making sure the bucket exists, and then defining an appropriate configuration in your HCL:

```hcl
terraform {
  backend "s3" {
    bucket  = "REPLACE-WITH-YOUR-STATE-BUCKET-NAME"
    key     = "exercise-10/terraform.tfstate"
  }
}
```

_ASIDE: The above is the first time we're seeing the root `terraform` block or stanza. In many cases, it's sole use will be to define a remote backend, but it also allows you to do things like define a required Terraform version via
semantic version syntax. See https://www.terraform.io/docs/configuration/terraform.html for more info._

If we look at the backend definition above, we see two things that define where state should exist:

1. The S3 bucket to put the state in
1. The `key` or path within that bucket to the state file

Without further ado, let's try some of this out.

### First, we need to make sure our state bucket exists

1. We'll use Terraform to create the state bucket:

 ```bash
 cd state-bucket
 terraform init
 terraform apply
 ```

 The output of the apply above should be something like

 ```
 An execution plan has been generated and is shown below.
 Resource actions are indicated with the following symbols:
     + create

 Terraform will perform the following actions:

  # aws_s3_bucket.state_bucket will be created
  + resource "aws_s3_bucket" "state_bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = (known after apply)
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = "devint-"
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = true
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

 Plan: 1 to add, 0 to change, 0 to destroy.

 Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.

     Enter a value: yes

 aws_s3_bucket.state_bucket: Creating...
aws_s3_bucket.state_bucket: Creation complete after 5s [id=devint-...-20190623022126911700000001]

 Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

 Outputs:

 state_bucket_name = devint-...-20190623022126911700000001
```

 Before we move on, you may be asking yourself–what about the state for this state bucket? And it's a good
 question. In this case, we're just accepting that we're maintaining a local state for the bucket itself. There are a number of different paths you can take here including just ensuring that the bucket exists manually. The general idea is that whatever manages this state bucket, be it manual or automated, should be by itself, easily recreatable and not buried in a bunch of other automation.

2. Copy the value of your `state_bucket_name` output from the output of your apply, we'll use it for setting the remote
backend configuration.

### Now using our state bucket for the rest of our terraform

3. Now that our state bucket is there, we can actually start using it, so from this directory, execute the followiung

 ```bash
 # get back to the root folder of this exercise
 cd ..
 terraform init -backend-config=backend.tfvars
 ```
 The above will prompt you for the backend bucket name to use

 ```
 Initializing the backend...
 bucket
     The name of the S3 bucket

     Enter a value:
 ```

 You'll want to enter the bucket name that was output from your `state-bucket` terraform run.

 Notice this slightly-different `init` command–it accepts backend configuration variables. The Terraform settings and backend configuration block in a `.tf` file **CANNOT** accept or process interpolations. We can, however, still parameterize this stuff. This is particularly useful for things like secrets or other secure stuffyou might pass  into backend configuration. You can store it temporarily outside of your infrastructure code and simply instruct Terraform to use these values.

4. Now let's move on to our plan and apply

 ```bash
 terraform plan -out=plan.out
 ```

 For _fun_, we've thrown in an explicit saving of the plan to a file, and then applying that plan. Recent versions of
 Terraform have automated similar processes, so in most cases, just running `terraform apply` will ensure that it runs a plan and then asks you to accept that plan before continuing. This alternative method affords another way that was previously considered best practice and continues to be a good option for more-automated terraform execution scenarios like CI/CD pipelines for recording the plan artifact as an example.

 With the plan saved to the `plan.out` file, we can execute our `apply` to implement that plan:

 ```bash
 terraform apply plan.out
 ```

 You should get something similar to below:

 ```
 aws_s3_bucket_object.user_student_alias_object: Creating...
 aws_s3_bucket_object.user_student_alias_object: Creation  complete after 1s [id=student.alias]

 Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```

 Pretty similar outcome as far as the "infrastructure" is concerned. But, let's finish by taking a closer look at the
 state since it now exists remotely. You can either head over the S3 area of the AWS console and navigate to your state bucket to look around, or you could just use the AWS CLI to look as well:

 ```bash
 aws s3 ls s3://[your s3 state bucket name]/exercise-10/
 ```

 which should give you something like

 ```
 2020-10-12 20:35:33       1186 terraform.tfstate
 ```

 Your state file is appropriately stored in this remote location. Remote state isn't the extent of things teams need to do to address safe and maintainable collaboration on infrastructure using terraform. Another is state locking, such as the case of:

 * April is testing some changes to the Terraform source to remove a DB instance that is no longer needed against the staging infrastructure
 * At the same time, Matt is running the current version of the Terraform code against staging to test some other things, but his changes still have the DB that April is removing
    * April's removal might succeed, but then the DB is immediately recreated by Matt's run. April might be scratching her head in 10 minutes wondering how that DB has reappeared!


 * Locking the state file can address situations like the above and many other problematic scenarios in team collaboration using Terraform. We won't examine the details of state locking as an exercise.

 * What's important to know for the sake of this course around remote state locking:
  * The S3 backend has built-in support for state locking via a Dynamo DB table

* The above can simply be accomplished via the backend config:

 ```hcl
 terraform {
    backend "s3" {
      encrypt         = true
      bucket          = "REPLACE-WITH-YOUR-STATE-BUCKET-NAME"
      dynamodb_table  = "terraform-state-lock-dynamo"
      region          = us-east-2
      key             = "exercise-10/terraform.tfstate"
    }
  }
 ```

### Finishing up

Let's destroy everything we've created here:

```bash
terraform destroy
cd state-bucket
terraform destroy
```
