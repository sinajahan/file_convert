file_convert
============

A gem that is a wrapper around google drive to convert files to different formats.

It uses a aws s3 bucket as a resource to download the file to a temp folder.
Then uploads it to google drive and downloads the file as text.
After it is done with conversion it will delete the file from google drive so we are not storing the file there.
Also we don't need to pay for space on google drive.

Load test: The current rate is one resume each five minutes so the load is not a concern.
