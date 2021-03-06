# Backup From Repositories

Este é um script simples para fazer backup de todos os seus repositórios no GitHub e compacta-los em arquivos zip. Ele também permite que você escolha fazer backup apenas dos repositórios públicos ou privados de uma vez.

### Dependências

Você vai precisar do:

- bash
- curl
- git

E é isso aí.

## Configuração

Antes de começar os backups, talvez seja necessário realizar alguma configuração. Por isso, dê uma olhada nas opções abaixo:

### Para realizar apenas o backup dos repositórios públicos

Nesse caso, você não precisa gerar um token de acesso pessoal do GitHub ou pegar um existente. Apenas informe o seu username quando solicitado pelo script.

E sim, com esse script você pode fazer backup dos repositórios públicos de QUALQUER usuário do GitHub. Bem legal, né?

### Para realizar apenas o backup dos repositórios privados

Para essa opção, você precisa [criar um token de acesso pessoal do GitHub ou pegar um existente](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) que tenha controle total sobre os repositórios privados. Depois, você precisa colocá-lo dentro do arquivo `.env` para permitir que o script obtenha as informações dos seus repositórios privados.

Basta mudar o valor do GITHUB_PERSONAL_ACCESS_TOKEN no `.env`, desse jeito:

`GITHUB_PERSONAL_ACCESS_TOKEN=sua-chave-pessoal-chique`

### Para realizar o backup de todos os repositórios (públicos e privados)

Apenas faça a [configuração anterior](#para-realizar-apenas-o-backup-dos-repositórios-privados) e você estará pronto para baixar todos os seus repositórios.

## Usando o script

Primeiro, você pode clonar o repositório para o seu computador:

`$ git clone https://github.com/brendaw/backup-from-repos`

Ou, você pode baixar os arquivos com esse comando do curl:

`$ curl --remote-name-all https://raw.githubusercontent.com/brendaw/backup-from-repos/master/{.env,backup-from-repos.sh}`

Depois de baixar, dê permissão de execução para o script, como abaixo:

`$ chmod +x backup-from-repos.sh`

Após ter o script em mãos, escolha a sua opção de backup:

### Para realizar apenas o backup dos repositórios públicos

Execute o script com o argumento `public` e informe o seu usuário quando solicitado pelo script, da seguinte forma:

`$ ./backup-from-repos.sh public`

### Para realizar apenas o backup dos repositórios privados

Depois que você [configurar o seu token de acesso pessoal do GitHub](#para-realizar-apenas-o-backup-dos-repositórios-privados), execute o script com o argumento `private`. Como o token de acesso pessoal já está conectado ao seu usuário, o script não precisará pedir essa informação para você. Apenas rode o script como descrito abaixo:

`$ ./backup-from-repos.sh private`

### Para realizar o backup de todos os repositórios (públicos e privados)

Depois que você [configurar o seu token de acesso pessoal do GitHub](#para-realizar-apenas-o-backup-dos-repositórios-privados), execute o script com o argumento `all`. Como o token de acesso pessoal já está conectado ao seu usuário, o script não precisará pedir essa informação para você. Apenas rode o script como descrito abaixo:

`$ ./backup-from-repos.sh all`

## Contribuindo

Você pode contribuir de várias maneiras: criando novas funcionalidades, corrigindo eventuais bugs, melhorando a documentação e os exemplos ou traduzindo a documentação para a sua língua. As seções de [Issues](https://github.com/brendaw/backup-from-repos/issues) e [Pull Requests](https://github.com/brendaw/backup-from-repos/pulls) estão esperando a sua contribuição.

## Licença

[MIT](LICENSE) - William Brendaw - 2020