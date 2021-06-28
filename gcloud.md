# Create a VM with custom specs
```
gcloud compute instances create my-vm --custom-cpu 4 --custom-memory 5
```

```
gcloud alpha resource-manager tags bindings create \
--tag-value=TAGVALUE_NAME \
--parent=RESOURCE_ID
--location=LOCATION

gcloud alpha resource-manager tags bindings list \
    --parent=RESOURCE_ID \
    --location=LOCATION
```

https://cloud.google.com/resource-manager/docs/tags/tags-creating-and-managing#gcloud_8
