# Enrou Impact Grid System Overview
`Written by Sami Yerunkar`

The impact grid is a component of the [Enrou Website](http://enrou.co) that allows users to quickly search and filter through our product catalog. It consists of two major components:
- The client-side code, written in [React](https://facebook.github.io/react/)
- Cloud services that live on [AWS](https://aws.amazon.com/what-is-aws/) which make up the back-end of the impact grid.

## Client
**Source Code:** [https://bitbucket.org/enrou/impact-grid](https://bitbucket.org/enrou/impact-grid)

The impact grid client is written in React and [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html). In production, it lives as a minified and gzipped .js file in Enrou's shopify theme's assets folder. It his highly recommended that all edits are made through the jsx transpilation process. More detailed instructions are given in the file [modifying.md](https://bitbucket.org/enrou/impact-grid/src/562eb8e413ad02ea9a6842d5f30d4054ea30f30b/modfying.md?at=master&fileviewer=file-view-default), located at the root of the repository.

## AWS
AWS resources can only be accessed by users with the correct credentials. Credentials may be granted to new users through the [IAM Console](https://console.aws.amazon.com/iam/home?#home). Please follow the corresponding guide [here](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_delegate-permissions.html). This step is mandatory in order to use the AWS CLI. While all services can be modfied without using the AWS CLI, it is not advisable to do so for some services. You can find more details in the description of each subsystem below. Please follow the [CLI Getting Started Guide](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html).

Some EC2 services require manual ssh entry for configuration or modification. Please follow [this guide](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) to access these resources through SSH. Be mindful of the .pem key required for each resource.

## Subsystems
Enrou's impact tiles are divided up into services represented by AWS resources. This document aims to identify the location, and purpose of each of these resources, as well as inform the reader about deployment best practices that may be in place. The subsystems are listed as follows:
- **Elasticsearch Service (EC2)**
- **Impact Tile Data Service (Elastic Beanstalk)**
- => Tile CMS
- => Data endpoint
- **Impact Tile Batch Sync Service (EC2)**
- **CDN (Cloudfront)**
- **MySQL Database (RDS)**
- **DNS (Route 53)**

.

.

.

## Elasticsearch Service

Resource Type | Access Method | Key
------------- | ------------- | ------------------------------------------------------------------------------------------------
EC2           | SSH           | [enrou-elasticsarch.pem](https://www.dropbox.com/s/limvl82x4flky2t/enrou-elasticsearch.pem?dl=0)

The Elasticsearch service is a heft m3.large EC2 instance that holds a runs an [Elasticsearch](https://www.elastic.co/products/elasticsearch) server. The data that resides in the server is configured and placed by other services, such as the Impact Tile Data Service. As such, no configuration or application code resides in this service. It can be substituted in for any other Elasticsearch instance with no change in behavior, provided that the data is replicated correctly.

## Impact Tile Data Service

Resource Type     | Access Method | Source Code                                              | Resource Link
----------------- | ------------- | -------------------------------------------------------- | 
Elastic Beanstalk | AWS CLI       | [data-scraper](https://bitbucket.org/enrou/data-scraper) | [rails-impact-service](https://us-west-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-west-1#/environment/dashboard?applicationName=data-scraper&environmentId=e-ps6aktsecg)

This is the heart of the back-end. It is broken down into two components, both of them residing as a part of the same rails app. The first one is the **CMS**. In the source code, CMS resides mostly in the `app/view/tiles` directory and all rails resources that it links to. The CMS allows users to upload "custom tiles", impact tiles that do not fall under the category of Brand, Cause, Product, or Collection. This was created to intersperse the grid with tidbits of useful links and information. The second component is the API endpoint, found in `/app/controllers/controllers /test_controller.rb`, and all of the Controllers and Models that correspond with Tile, Product, Brand, Cause, and Collection. The models contains logic that dictates how the data for each model is stored in elasticsearch. Elasticsearch integration is powered by [searchkick](https://github.com/ankane/searchkick). I highly recommend reading the searchkick documentation to understand how it works. This service also depends on the MySQL database, which is outlined in another section of this document.

## Impact Tile Batch Sync Service

Resource Type | Access Method | Source Code                                              | Key
------------- | ------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------------------------
EC2           | SSH           | [data-scraper](https://bitbucket.org/enrou/data-scraper) | [enrou-elasticsarch.pem](https://www.dropbox.com/s/limvl82x4flky2t/enrou-elasticsearch.pem?dl=0)

The Batch Sync Service takes Enrou's product data using the Shopify API every two hours and loads it into the database and the elasticsearch server. This service is deployed as an EC instance that runs independently of the Impact Tile Data Service, despite sharing the same source code respository. The respository is shared to reuse the models, schema information, and searchkick integration as the Data Service. Please read up on the [Shopify API documentation](https://docs.shopify.com/api) for more information.

## CDN

Resource Type | Access Method   | Cloudfront Link                                                                                                        | S3 Link
------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------- | 
Cloudfront/S3 | AWS CLI/Console | [E2EMF2ERSFF85R](https://console.aws.amazon.com/cloudfront/home?region=us-west-1#distribution-settings:E2EMF2ERSFF85R) | [enrou-cdn](https://console.aws.amazon.com/s3/home?region=us-west-1#&bucket=enrou-cdn&prefix=)

This is a very standard Cloudfront resource. Please read the documentation for [Cloudfront](https://aws.amazon.com/documentation/cloudfront/) and [S3](https://aws.amazon.com/documentation/s3/)

.

## MySQL Database

Resource Type | Access Method | Resource Link
------------- | ------------- | --------------------------------------------------------------------------------------------------------------------
RDS           | AWS Console   | [impactdb2](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#dbinstances:id=impactdb2;sf=all;v=mm)

This is a standard MySQL database hosted on Amazon RDS. Please read the [RDS documentation](https://aws.amazon.com/documentation/rds/). It should not be directly accessed unless absolutely necessary.

## DNS

Resource Type | Access Method | Resource Link
------------- | ------------- | ---------------------------------------------------------------------------------------
Route 53      | AWS Console   | [enrou.co.](https://console.aws.amazon.com/route53/home?region=us-west-1#hosted-zones:)

The DNS sets up the domains, elastic IP's, and load balancers for the entire system. This allows the cdn to live at `files.enrou.co`, the Data service to live at `data.enrou.co`, and the main site to live at `enrou.co`. Please modify this at your own risk. Please read the [Route 53 documentation](https://aws.amazon.com/documentation/route53/).
