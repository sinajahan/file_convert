file_convert
============

A gem that is a wrapper around google drive to convert files to different formats.

For setting up the converter you need a google drive api access and you need a service account for authentication.
Please visit [this](https://code.google.com/apis/console) to get your info.

You also need S3 bucket setup with group policy that has put and get access.
You also need to provide a temp location. The main reason for this was so we can change the temp folder on heroku.

It uses a aws s3 bucket as a resource to download the file to a temp folder.
Then uploads it to google drive and downloads the file as text.
After it is done with conversion it will delete the file from google drive so we are not storing the file there.
Also we don't need to pay for space on google drive.

The gem uses exception handling for communicating with container.
Load test: The current rate is one resume each five minutes so the load is not a concern.
