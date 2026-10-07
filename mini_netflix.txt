! =================================================================
!  MINI-NETFLIX - Catalogo de Filmes (CLI)
!  Linguagem: Fortran 90 | Paradigma: Imperativo (procedural)
!  Grupo 2: Hiccaro, Joao Pedro e Marques Vinicius
! =================================================================
program mini_netflix
    implicit none

    ! Registro (struct) de um filme: so guarda dados, nao tem metodos
    type :: filme
        character(len=50) :: titulo
        character(len=50) :: diretor
        character(len=50) :: genero
        integer           :: ano
    end type filme

    integer, parameter :: MAX_FILMES = 100

    ! ESTADO DO PROGRAMA: um vetor fixo de filmes + um contador.
    ! As sub-rotinas abaixo leem e alteram essas variaveis diretamente.
    type(filme) :: catalogo(MAX_FILMES)
    integer     :: total = 0
    integer     :: opcao

    ! Alguns filmes ja cadastrados para facilitar a demonstracao
    call adicionar('Matrix', 'Lana e Lilly Wachowski', 1999, 'Ficcao Cientifica')
    call adicionar('O Poderoso Chefao', 'Francis Ford Coppola', 1972, 'Drama')
    call adicionar('Toy Story', 'John Lasseter', 1995, 'Animacao')

    ! Laco principal: mostra o menu e executa a opcao escolhida
    do
        print '(A)', ''
        print '(A)', '========= MINI-NETFLIX ========='
        print '(A)', ' 1 - Cadastrar filme'
        print '(A)', ' 2 - Listar filmes'
        print '(A)', ' 3 - Buscar filme pelo titulo'
        print '(A)', ' 4 - Excluir filme'
        print '(A)', ' 0 - Sair'
        print '(A)', '================================'
        opcao = ler_inteiro('Escolha uma opcao: ')

        select case (opcao)
        case (1)
            call cadastrar()
        case (2)
            call listar()
        case (3)
            call buscar()
        case (4)
            call excluir()
        case (0)
            print '(A)', 'Saindo... Ate logo!'
            exit
        case default
            print '(A)', 'Opcao invalida!'
        end select
    end do

contains

    ! ---------- 1. CADASTRAR ----------
    subroutine cadastrar()
        character(len=50) :: titulo, diretor, genero
        integer :: ano

        if (total >= MAX_FILMES) then
            print '(A)', 'Catalogo cheio!'
            return
        end if

        titulo = ler_texto('Titulo: ')
        if (len_trim(titulo) == 0) then
            print '(A)', 'O titulo nao pode ficar vazio.'
            return
        end if
        if (encontrar(titulo) > 0) then
            print '(A)', 'Ja existe um filme com esse titulo.'
            return
        end if

        diretor = ler_texto('Diretor: ')
        ano     = ler_inteiro('Ano de lancamento: ')
        genero  = ler_texto('Genero: ')

        call adicionar(titulo, diretor, ano, genero)
        print '(A)', 'Filme cadastrado com sucesso!'
    end subroutine cadastrar

    ! Coloca um filme na proxima posicao livre e aumenta o contador
    subroutine adicionar(titulo, diretor, ano, genero)
        character(len=*), intent(in) :: titulo, diretor, genero
        integer, intent(in) :: ano

        total = total + 1
        catalogo(total) = filme(titulo, diretor, genero, ano)
    end subroutine adicionar

    ! ---------- 2. LISTAR ----------
    subroutine listar()
        integer :: i

        if (total == 0) then
            print '(A)', 'Nenhum filme cadastrado.'
            return
        end if

        print '(A,I0,A)', '--- Catalogo (', total, ' filmes) ---'
        do i = 1, total
            call mostrar_filme(i)
        end do
    end subroutine listar

    ! ---------- 3. BUSCAR ----------
    subroutine buscar()
        integer :: i

        i = encontrar(ler_texto('Titulo a buscar: '))
        if (i == 0) then
            print '(A)', 'Filme nao encontrado.'
        else
            call mostrar_filme(i)
        end if
    end subroutine buscar

    ! ---------- 4. EXCLUIR ----------
    subroutine excluir()
        integer :: i

        i = encontrar(ler_texto('Titulo a excluir: '))
        if (i == 0) then
            print '(A)', 'Filme nao encontrado.'
            return
        end if

        print '(A)', 'Filme "' // trim(catalogo(i)%titulo) // '" excluido.'
        ! Puxa os filmes seguintes uma posicao para tras e diminui o contador
        catalogo(i:total-1) = catalogo(i+1:total)
        total = total - 1
    end subroutine excluir

    ! ---------- Funcoes auxiliares ----------

    ! Busca linear: retorna a posicao do filme no vetor (0 = nao achou).
    ! Ignora maiusculas/minusculas.
    integer function encontrar(titulo)
        character(len=*), intent(in) :: titulo
        integer :: i

        encontrar = 0
        do i = 1, total
            if (minusculo(catalogo(i)%titulo) == minusculo(titulo)) then
                encontrar = i
                return
            end if
        end do
    end function encontrar

    subroutine mostrar_filme(i)
        integer, intent(in) :: i

        print '(I0,A,A,A,I0,A,A,A,A)', i, '. ', trim(catalogo(i)%titulo), &
              ' (', catalogo(i)%ano, ') | Genero: ', trim(catalogo(i)%genero), &
              ' | Diretor: ', trim(catalogo(i)%diretor)
    end subroutine mostrar_filme

    ! Mostra uma mensagem e le uma linha inteira (aceita espacos)
    function ler_texto(msg) result(texto)
        character(len=*), intent(in) :: msg
        character(len=50) :: texto
        integer :: ios

        write(*, '(A)', advance='no') msg
        read(*, '(A)', iostat=ios) texto
        if (ios /= 0) stop   ! fim da entrada: encerra o programa
        texto = adjustl(texto)
    end function ler_texto

    ! Le um numero inteiro, repetindo a pergunta ate o valor ser valido
    integer function ler_inteiro(msg)
        character(len=*), intent(in) :: msg
        character(len=50) :: linha
        integer :: ios

        do
            linha = ler_texto(msg)
            read(linha, *, iostat=ios) ler_inteiro
            if (ios == 0) exit
            print '(A)', 'Valor invalido, digite um numero inteiro.'
        end do
    end function ler_inteiro

    ! Converte um texto para minusculas
    function minusculo(s) result(r)
        character(len=*), intent(in) :: s
        character(len=len(s)) :: r
        integer :: i, c

        r = s
        do i = 1, len(s)
            c = iachar(s(i:i))
            if (c >= iachar('A') .and. c <= iachar('Z')) r(i:i) = achar(c + 32)
        end do
    end function minusculo

end program mini_netflix
