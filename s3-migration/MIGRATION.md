# Minio S3 Migration

In order to migrate the Minio S3 data + metadata, one has to spin up a temporary (newer) Minio S3 instance.

Steps (in theory):
- Create new VM
- Deploy temporary Minio S3 instance
- Migrate metadata + bucket data from old instance to temporary instance
- Shutdown the old instance
    - Also clear its data/config mounts
- Re-deploy a new instance with the new backend version to replace the old instance
- Migrate metadata + bucket data from temporary instance to the new instance


## Commands/Steps to run

- `$ terraform apply -var-file="secrets.tfvars" -target hcloud_server.s3-migration`
- Adjust the DNS settings of these zones:
    - `s3-mig.forgejo.dev`
    - `s3.s3-mig.forgejo.dev`
    - `console.s3.s3-mig.forgejo.dev`
- `$ ansible-playbook s3-mig.yaml -l s3-mig`
- Verify that the temporary instance is available at https://consolse.s3.s3-mig.forgejo.dev
- [Install `mc`](https://min.io/docs/minio/linux/reference/minio-mc.html) on your local machine if not already done
- Set the environment variables:
    - `$ export ACCESS_KEY=123`
    - `$ export SECRET_KEY=456`
    - `$ export SOURCE=https://s3.forgejo.dev`
    - `$ export TARGET=https://s3.s3-mig.forgejo.dev`
- `$ cd s3-migration && chmod +x migration.sh && ./migration.sh`
    - Wait until the mirror process has finished
- Stop the old instance: `$ cd /srv/docker-compose/minio && docker-compose down`
- Delete or rename the old data folders: `$ cd /srv/docker-compose/minio && mv minio-config minio-config_old && mv minio-data minio-data_old`
- Re-deploy Minio S3 with the new backend: `$ ansible-playbook s3.yaml -l production`
- Set the environment variables but replace `SOURCE` with `TARGET` and vice versa:
    - `$ export ACCESS_KEY=123`
    - `$ export SECRET_KEY=456`
    - `$ export SOURCE=https://s3.s3-mig.forgejo.dev`
    - `$ export TARGET=https://s3.forgejo.dev`
- `$ cd s3-migration && chmod +x migration.sh && ./migration.sh`
    - Wait until the mirror process has finished
- Verify that all data has successfully been migrated to the new instance
- Stop the temporary instance and destroy the VM: `$ terraform destroy -var-file="secrets.tfvars" -target hcloud_server.s3-migration`


## References

- https://min.io/docs/minio/linux/operations/install-deploy-manage/migrate-fs-gateway.html
- https://min.io/docs/minio/linux/operations/install-deploy-manage/deploy-minio-single-node-single-drive.html#minio-snsd
- https://min.io/docs/minio/linux/reference/minio-mc.html
