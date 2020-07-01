# Backup From Repositories

_Leia isso em [Português](README-pt-BR.md)._

This is a simple script to backup all your GitHub repositories and put then into zip files. It also let you choose if you want to download only the private or the public repositories at a time.

### Dependencies

First of all, you need:

- bash
- curl
- git

And that's it.

## Configuration

Before you begin the backups, you may need some configuration. So, take a look in the options bellow:

### To backup only public repos

In this case, you don't need to generate a personal access token or get an existing one. Just pass your username when prompted by script.

And yeah, with this script you can backup all public repositories from ANY user in the GitHub. Pretty cool, huh?

### To backup private repos

For this option, you need to [create or get some of yours GitHub personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) with at least full control of private repositories. Then, you need to put it in the `.env` file to retrieve your private repos info.

You will change the GITHUB_PERSONAL_ACCESS_TOKEN value in `.env`, like that:

`GITHUB_PERSONAL_ACCESS_TOKEN=your-fancy-personal-key`

### To backup both public and private repos

Simple do the [previously configuration](#to-backup-private-repos) and you will be fine.

## Using it

First, you can clone the repository to your machine:

`$ git clone https://github.com/brendaw/backup-from-repos`

Or, you can download the files with this curl command:

`$ curl --remote-name-all https://raw.githubusercontent.com/brendaw/backup-from-repos/master/{.env,backup-from-repos.sh}`

After download, give execution permission to the script, as bellow:

`$ chmod +x backup-from-repos.sh`

Then, choose your backup option:

### To backup only public repos

Run the script with `public` arg and pass your user when asked, like below:

`$ ./backup-from-repos.sh public`

### To backup only private repos

After you [configure your personal access token](#to-backup-private-repos), run the script with `private` arg. Since the private access token already have your user binded, the script will not ask for your user. Just run like below:

`$ ./backup-from-repos.sh private`

### To backup both public and private repos

After you [configure your personal access token](#to-backup-both-public-and-private-repos), run the script with `all` arg. Since the private access token already have your user binded, the script will not ask for your user. Just run like below:

`$ ./backup-from-repos.sh all`

## Contributing

You may contribute in several ways like creating new features, fixing bugs, improving documentation and examples or translating any document here to your language. [Issues](https://github.com/brendaw/backup-from-repos/issues) and [Pull Requests](https://github.com/brendaw/backup-from-repos/pulls) sections are waiting for your contribution.

## License

[MIT](LICENSE) - William Brendaw - 2020