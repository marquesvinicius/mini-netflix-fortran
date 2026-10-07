# 🎬 Mini-Netflix em Fortran

Trabalho de **Paradigmas de Programação** (UniRV): um catálogo de filmes via terminal (CLI), escrito em **Fortran 90** seguindo o **paradigma imperativo**.

**Grupo 2:** Hiccaro, João Pedro e Marques Vinícius

## Funcionalidades

| Requisito | Onde está no código |
|---|---|
| Cadastrar filme (Título, Diretor, Ano, Gênero) | `subroutine cadastrar` + `subroutine adicionar` |
| Listar todos os filmes | `subroutine listar` |
| Buscar filme pelo título | `subroutine buscar` + `function encontrar` |
| Excluir filme | `subroutine excluir` |

Os dados ficam em memória, num vetor fixo de 100 posições. O programa já começa com 3 filmes cadastrados para a demonstração.

## Como executar

**Windows (sem instalar nada):** baixe o repositório e dê dois cliques em `executar.bat` (ou em `mini_netflix.exe`).

**Compilando (Linux/macOS/Windows com gfortran):**

```bash
gfortran mini_netflix.f90 -o mini_netflix
```

```bash
./mini_netflix
```

**Online:** cole o código de `mini_netflix.f90` em [onlinegdb.com](https://www.onlinegdb.com) (linguagem Fortran) e clique em *Run*.

Mais detalhes em [`read-me.txt`](read-me.txt).

## Como o paradigma imperativo aparece no código

- **Estado global mutável:** todo o catálogo é só um vetor `catalogo(100)` e um contador `total`, declarados no programa principal.
- **Sem objetos:** `type :: filme` é apenas um registro de dados (como uma `struct` em C), sem métodos.
- **Sub-rotinas alteram o estado diretamente:** `adicionar` faz `total = total + 1`; `excluir` desloca os elementos do vetor (`catalogo(i:total-1) = catalogo(i+1:total)`) e faz `total = total - 1`.
- **Fluxo de controle explícito:** laço `do` infinito com `select case` para o menu, e busca linear com `do i = 1, total`.

## Estrutura

```
mini_netflix.f90   código-fonte
mini_netflix.txt   cópia do código em texto (exigência da entrega)
mini_netflix.exe   executável pronto para Windows
executar.bat       atalho para rodar no Windows
compilar.bat/.sh   recompilar com gfortran
read-me.txt        instruções de execução
```
