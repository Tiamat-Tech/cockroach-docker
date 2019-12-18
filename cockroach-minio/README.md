### This is a tutorial based on a single node CockroachDB cluster and Minio cloud storage sink for [changefeed](https://www.cockroachlabs.com/docs/stable/change-data-capture.html#create-a-changefeed-connected-to-a-cloud-storage-sink). As of 19.2.2 configurable changefeeds require an enterprise license of CockroachDB.

 - [CockroachDB](https://www.cockroachlabs.com/docs/stable/enterprise-licensing.html)
 - [Minio](https://hub.docker.com/r/minio/minio/)

https://docs.min.io/docs/aws-cli-with-minio
https://www.cockroachlabs.com/docs/v19.2/backup.html#backup-file-urls under S3-compatible services

```sql
CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://miniobucket/test?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=https://minio:9000' with updated, resolved='10s';
```

```bash
root@:26257/cdc_demo> CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://miniobucket/test?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=https://minio:9000' with updated, resolved='10s';
        job_id
+--------------------+
  513233256858746881
(1 row)

Time: 26.0877ms
```



