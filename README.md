File Convert
============

A gem that is a wrapper around google drive to convert files to different formats.

Dependency
----------
* Google drive API
* Google OATH service account
* AWS S3 bucket
* AWS user policy with put/get/list permissions
* Access to a system folder with write permission

Flow
----
1. Gem receives a s3 key (optional)
1. Gem downloads the file from s3 bucket (optional)
1. Gem uploads the file to google drive
1. Gem downloads the file meta data from google drive
1. Gem uses the export-to-txt link from meta data to get the text file
1. Gem deletes the file from google drive

Google drive
------------
For setting up the converter you need a google drive api access and you need a service account for authentication.
Please visit [this](https://code.google.com/apis/console) to get your info.
The google service account is using a private key for authentication. I have put that inside the gem and since the gem
is getting severed through gemfury it is safe.

S3
--
You also need S3 bucket setup with group policy that has put and get access.
You also need to provide a temp location. The main reason for this was so we can change the temp folder on heroku.

Logs & Exceptions
-----------------
The gem uses exception handling for communicating with container. It uses FileConvert::TransientError and FileConvert::UserError for errors.

Security
--------
Gem does not need delete access to s3 bucket. The put access is only for testing. The remove right is intentionally removed so it can't be a security hole.

Config
------
Take a look at config.sample.yml as a start point.


*Load test:* The current rate is one resume each five minutes so the load is not a concern.



