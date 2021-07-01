# COSBU - A utility to back up object storage using a simple Docker container with rclone and shell scripts.
It can run in any environment, but was designed to run on a cloud provider's serverless infrastructure, 
so that COS back up will not incur egress charges.  It has only been tested on IBM's Code Engine service.  

There are two command line options:  
* check - Compares the COS buckets to see if they are in sync.
* sync - Uses rclone's sync option to synchronize the TARGET bucket with the SOURCE.  NOTE:  This includes deleting files in the target that have been deleted from the source.

The container expects the following environment variables:  
COSBU_SRC_ACCESSKEY - The Access Key for the Source COS instance  
COSBU_SRC_SECRETKEY - The Secret Access Key for the Source COS instance  
COSBU_SRC_ENDPOINT -  The Source endpoint.  Use the COS provider's INTERNAL   endpoint here to avoid egress charges.  On IBM COS this is the "direct" endpoint.  
COSBU_SRC_BUCKET - The Source bucket  
  
TGTBU_SRC_ACCESSKEY - The Target Key for the Source COS instance  
TGTBU_SRC_SECRETKEY - The Target Access Key for the Source COS instance  
TGTBU_SRC_ENDPOINT -  The Target endpoint.  Use the COS provider's INTERNAL endpoint here to avoid egress charges.  On IBM COS this is the "direct" endpoint.  
TGTBU_SRC_BUCKET - The Target bucket  