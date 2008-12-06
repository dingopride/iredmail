#!/bin/sh

# Author: Zhang Huangbin <michaelbibby (at) gmail.com>

# -------------------------------------------------------
# ---------------- User/Group: vmail --------------------
# -------------------------------------------------------
adduser_vmail()
{
    homedir="$(dirname $(echo ${VMAIL_USER_HOME_DIR} | sed 's#/$##'))"
    [ -d ${homedir} ] || mkdir -p ${homedir}

    ECHO_INFO "Add user/group: vmail."
    groupadd ${VMAIL_GROUP_NAME}

    # Set permission for exist home directory.
    if [ -d ${VMAIL_USER_HOME_DIR} ]; then
        chown -R ${VMAIL_USER_NAME}:${VMAIL_GROUP_NAME} ${VMAIL_USER_HOME_DIR}
        chmod -R 0700 ${VMAIL_USER_HOME_DIR}
    else
        :
    fi

    useradd -m -d ${VMAIL_USER_HOME_DIR} -s /sbin/nologin ${VMAIL_USER_NAME}
    rm -f ${VMAIL_USER_HOME_DIR}/.* 2>/dev/null

    # Export vmail user uid/gid.
    export VMAIL_USER_UID="$(id -u ${VMAIL_USER_NAME})"
    export VMAIL_USER_GID="$(id -g ${VMAIL_USER_NAME})"

    cat >> ${TIP_FILE} <<EOF
Mail Storage:
    - Path:
        ${VMAIL_USER_HOME_DIR}
    - Format:
        ${VMAIL_USER_HOME_DIR}/DomainName/UserName/
    - Example:
        ${VMAIL_USER_HOME_DIR}/${FIRST_DOMAIN}/${FIRST_USER}/

EOF

    echo 'export status_adduser_vmail="DONE"' >> ${STATUS_FILE}
}
