file_convert
============
A gem that is a wrapper around google drive to convert files to different formats.

It uses a aws s3 bucket as a resource to download the file to a temp folder and then uploads it to google drive and downloads the file as text.

Load test: The current rate is one resume each five minutes so the load is not a concern.
