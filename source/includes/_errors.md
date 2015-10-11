# Errors

The RingCentral for Developers API uses the following error codes:


Error Code | Meaning
---------- | -------
400 | Bad Request -- Your request is incorrectly formatted
401 | Unauthorized -- Your API key is wrong
403 | Forbidden -- The resource requested is hidden for administrators only
404 | Not Found -- The specified resource could not be found
405 | Method Not Allowed -- You tried to access a resource with an invalid method
410 | Gone -- The resource requested has been removed from our servers
429 | Too Many Requests -- You're making too many requests! Slown down!
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarially offline for maintanance. Please try again later.