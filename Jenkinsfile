pipeline {
    agent any
    environment {
        container='openldap'
        image='openldap'
        d_volumes="${container}.etc_openldap ${container}.var_db"
        d_vol_args="-v ${container}.etc_openldap:/etc/openldap:Z -v ${container}.var_db:/var/db:Z"
        network='jenkins'
    }
    options { disableConcurrentBuilds() }
    parameters {
        string(defaultValue: 'True', description: '"True": initial cleanup: remove container and volumes; otherwise leave empty', name: 'start_clean')
        string(defaultValue: '', description: '"True": "Set --nocache for docker build; otherwise leave empty', name: 'nocache')
        string(defaultValue: '', description: '"True": push docker image after build; otherwise leave empty', name: 'pushimage')
        string(defaultValue: '', description: '"True": keep running after test; otherwise leave empty to delete container and volumes', name: 'keep_running')
    }

    stages {
        stage('Cleanup ') {
            when {
                expression { params.$start_clean?.trim() != '' }
            }
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    remove_containers $container && echo '.'
                    remove_volumes $d_volumes && echo '.'
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    remove_container_if_not_running
                    if [[ "$nocache" ]]; then
                         nocacheopt='--no-cache'
                         echo 'build with option nocache'
                    fi
                    docker build $nocacheopt -t $image .
                '''
            }
        }
        stage('Setup') {
            steps {
                sh '''#!/bin/bash -e
                    source ./jenkins_scripts.sh
                    create_docker_network
                    ttyopt=''; [[ -t 0 ]] && ttyopt='-t'  # autodetect tty
                    docker run -i $ttyopt --rm --name $container --env-file=env $d_vol_args $image /tests/init_rootpw.sh
                    echo "Starting $container"
                    export LOGLEVEL=conns,config,stats,shell
                    docker run --detach --rm --name $container --env-file=env --net=$network $d_vol_args $image
                    wait_for_container_up && echo "$container started"
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''#!/bin/bash +e
                    ttyopt=''; [[ -t 0 ]] && ttyopt='-t'  # autodetect tty
                    docker exec $ttyopt $container /tests/load_data.sh
                    docker exec $ttyopt $container /tests/test_00_all.sh
                    echo "'docker exec /tests/test_00_all.sh' returned code=${rc}"
               '''
            }
        }
        stage('Push ') {
            when {
                expression { params.pushimage?.trim() != '' }
            }
            steps {
                sh '''#!/bin/bash -e
                    default_registry=$(docker info 2> /dev/null |egrep '^Registry' | awk '{print $2}')
                    echo "  Docker default registry: $default_registry"
                    docker-compose $projop push
                    rc=$?
                    ((rc>0)) && echo "'docker-compose push' failed with code=${rc}"
                    exit $rc
                '''
            }
        }
    }
    post {
        always {
            sh '''#!/bin/bash -e
                if [[ "$keep_running" ]]; then
                    echo "Keep container running"
                else
                    source ./jenkins_scripts.sh
                    remove_containers $container && echo 'containers removed'
                    remove_volumes $d_volumes && echo 'volumes removed'
                fi
            '''
        }
    }
}