# yosetti.com

## 開発環境の事前準備
### 1. Laravelの環境変数を作成
各自の開発環境へ、サンプルの環境変数ファイルをコピーして利用します。
```shell
cp -f web/.env.local web/.env
```

### 2. インフラデプロイ用のDocker contextを作成
#### 2.1. Contextを作成
Dockerコマンドのデプロイ先にAWSを指定するために、専用のContextを作成します。
`例）プロファイル名が yosetti-rhythm である場合`
```shell
% docker context create ecs yosetti-com-ecs
? Create a Docker context using: An existing AWS profile
? Select AWS Profile yosetti-rhythm
```
作成されたContextの確認を行います。
```shell
% docker context ls
docker context ls
NAME                   TYPE                DESCRIPTION                               DOCKER ENDPOINT                                   KUBERNETES ENDPOINT   ORCHESTRATOR
default *              moby                Current DOCKER_HOST based configuration   unix:///var/run/docker.sock                                             swarm
desktop-linux          moby                                                          unix:///Users/hogehoge/.docker/run/docker.sock
yosetti-com-ecs        ecs
```
### 2.2. ECSアカウント設定変更
以下のコマンドでECSの各設定の状況を確認できます。LongArnFormatに関する項目が対象の設定になります。※実行結果の`value`が`enabled`になっていること
```shell
% aws ecs list-account-settings --effective-settings --profile yosetti-rhythm
{
    "settings": [
        ・・・
        {
            "name": "containerInstanceLongArnFormat",
            "value": "enabled",
            "principalArn": "arn:aws:iam::479857588847:user/aws-toolkit-user"
        },
        {
            "name": "containerLongArnFormat",
            "value": "enabled",
            "principalArn": "arn:aws:iam::479857588847:user/aws-toolkit-user"
        },
        {
            "name": "serviceLongArnFormat",
            "value": "enabled",
            "principalArn": "arn:aws:iam::479857588847:user/aws-toolkit-user"
        },
        {
            "name": "taskLongArnFormat",
            "value": "enabled",
            "principalArn": "arn:aws:iam::479857588847:user/aws-toolkit-user"
        }
        ・・・
    ]
}
```

有効になっていない場合は下記のコマンドを実行し、有効化します。
```
% aws ecs put-account-setting-default --name containerInstanceLongArnFormat --value enabled --profile yosetti-rhythm
% aws ecs put-account-setting-default --name containerLongArnFormat --value enabled --profile yosetti-rhythm
% aws ecs put-account-setting-default --name serviceLongArnFormat --value enabled --profile yosetti-rhythm
% aws ecs put-account-setting-default --name taskLongArnFormat --value enabled --profile yosetti-rhythm
```



## 開発環境の利用方法
### 1. 開発環境を起動
```shell
./command.sh Docker-Up
```

### 2. 必要なパッケージ群をインストール
※初回起動時またはブランチを切り替えた際に実行します
```shell
./command.sh Composer-Install
```

### 3. データベースの初期化
※初回起動時またはブランチを切り替えた際に実行します
```shell
./command.sh Init-DB
```

### 4. データベースへの接続

| 項目      | 値          |
|---------|------------|
| ホスト:ポート | 127.0.0.1:3306 |
| ユーザー名   | docker     |
| パスワード   | docker     |
| データベース  | docker     |


### 5. 開発環境を終了
```shell
./command.sh Docker-Down
```

### 6. その他
#### 6.1. PHP、Nginxコンテナを再ビルド
※PHP、Nginxコンテナに変更があった場合に実行します。
```shell
./command.sh Docker-Rebuild
```

#### 6.2. UnitTest
```shell
// 関数単位でのUnitTestを実行します
./command.sh UnitTest Unit

// Chromiumブラウザでe2eテストを実行します
./command.sh UnitTest Browser
```


## コンテナイメージのデプロイ方法
PHPやNginxの実行環境をデプロイします。
※PHPのバージョンアップやミドルウェアを追加した場合に実行します。コンテンツの変更時はありません。
### 試験環境へコンテナイメージをデプロイ
```shell
./command.sh Staging-ECR-Push
```

### 本番環境へコンテナイメージをデプロイ
```shell
./command.sh Production-ECR-Push
```

## 動作確認
### 開発環境
- https://yosetti.info/users/login
- https://admin.yosetti.info/

    ※hosts設定が必要になります。
    ```shell:hosts
    127.0.0.1		yosetti.info
    127.0.0.1		admin.yosetti.info
    ```

### 試験環境
- https://stg.yosetti.com/user/login
- https://stg-admin.yosetti.com/
