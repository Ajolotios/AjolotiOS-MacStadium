## [⬅️](./../README.md) .env Manual

The .env file created automatically, will contain bellow information.

```
ENV_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
ENV_RUNNERS_ID="XXX1 XXX2 XXX3"
```
- Follow [Token Manual](./manual_token.md) to get **ENV_TOKEN** value.

- Add as much runners IDs as you need in **ENV_RUNNERS_ID**.

> [!IMPORTANT]
> Each runner id must:
> - Be unique.
> - Contains 4 alphanumeric characters.
> - A whitespace (" ") must exist only between each id.
> - Does not exist in Github [RoVaMx Runners](https://github.com/organizations/RoVaMx/settings/actions/runners), if it exist and you dont need it, remove it.