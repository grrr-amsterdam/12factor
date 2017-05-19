# Content Sync Scripts
Various scripts to synchronize uploads and databases.

Call these scripts with `sh`, like so:

```shell
$ sh sync-databases-remote-to-remote.sh \
    [source ssh user] [source ssh host] \
    [source db user] [source db name] [source db host] \
    [destination ssh user] [destination ssh host] \
    [destination db user] [destination db name] [destination db host]
```
Configuration values are accepted as arguments,
except for passwords, which can be set interactively or as environment variables.
You will be prompted for any missing parameters.
