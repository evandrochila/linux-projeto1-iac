#!/bin/bash

separator="--------------------------------------------------"

function delete_old_tests(){
    echo "Excluindo usuários criados anteriormente"
    USERS="carlos maria joao debora sebastiana roberto josefina amanda rogerio"
    for user in $USERS; do
        # Verificando se o usuário já existe
        if id "$user" >/dev/null 2>&1; then
            echo "Excluindo usuário $user"
            deluser --remove-home "$user"
        else
            echo "O usuário $user não existe"
        fi
    done

    echo "$separator"

    DIRS="/publico /adm /ven /sec"
    for dir in $DIRS; do
        echo "Excluindo diretório: $dir"
        rm -rf "$dir"
    done

    echo "$separator"

    GROUP_NAMES="GRP_ADM GRP_VEN GRP_SEC"
    for group in $GROUP_NAMES; do
        echo "excluindo group: $group"
        groupdel "$group"       
    done

    echo "$separator"
}

function createDirs(){
    # Criando diretórios
    DIRS="/publico /adm /ven /sec"
    for dir in $DIRS; do
        mkdir -p "$dir"
    done
    echo "$separator"
}

function createGroups() {
    # Criando grupos
    GROUP_NAMES="GRP_ADM GRP_VEN GRP_SEC"
    for group in $GROUP_NAMES; do
        if grep "$group" /etc/groups >/dev/null 2>&1; then
            echo "O grupo $group já existe"
        else
            groupadd "$group"
        fi
    done
    echo "$separator"
}

function createUsers() {
    # Criando usuários
    USERS="carlos maria joao debora sebastiana roberto josefina amanda rogerio"
    for user in $USERS; do
        # Verificando se o usuário já existe
        if id "$user" >/dev/null 2>&1; then
            syslog "O usuário $user já existe"
        else
            echo "Criando o usuário $user"
            sudo useradd "$user" -m -s /bin/bash -p $(openssl passwd Senha123)
        fi
    done
    echo "$separator"
}

function changePermissions(){
    #Adicionando usuários aos grupos
    GRP_ADM_USERS="carlos maria joao"
    GRP_VEN_USERS="debora sebastian roberto"
    GRP_SEC_USERS="josefina amanda rogerio"

    # Adm
    for user in $GRP_ADM_USERS; do
        addgroup "$user" GRP_ADM
    done
    echo "$separator"
    # Vendas
    for user in $GRP_VEN_USERS; do
        addgroup "$user" GRP_VEN
    done
    echo "$separator"
    # SEX
    for user in $GRP_SEC_USERS; do
        addgroup "$user" GRP_SEC
    done
    echo "$separator"

    # Definindo permissões das pastas
    chmod 777 /publico
    chmod 770 /adm
    chown root:GRP_ADM /adm
    chmod 770 /ven
    chown root:GRP_VEN /ven
    chmod 770 /sec
    chown root:GRP_SEC /sec
}

function main() {
    delete_old_tests
    createDirs
    createGroups
    createUsers
    changePermissions
}

main