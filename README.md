# - Bischierge -

**Bistro + Concierge = Bischierge** <br>
近くの飲食店にランダムで検索出来ることができるアプリケーションです。<br>
「今日、何食べる？」を、**Simple, Smart and Smooth User Flow**で解決する事がコンセプトです。

### PC view
![ezgif com-video-to-gif](https://user-images.githubusercontent.com/35006561/90004321-63915a80-dcd0-11ea-89ef-a65d7dfd3e11.gif)

### SP view
![20200812_191936](https://user-images.githubusercontent.com/35006561/90004702-0fd34100-dcd1-11ea-9ae5-9bc07bbc4290.GIF)

[Bischierge](https://www.bischierge.work/)

## Target users
- これから「何を食べようか」と悩む人
- これから恋人や友人と食事に行く際に、何処に行くか決められない人
- グルメサイトを見て、情報が多すぎて何処に行くべきか決められない人

## Functions
- 近所の飲食店をランダムで9件表示します。（HotPepperAPI/GoogleMapを利用）
  - 気分に合わせて洋食・和食・中華などの絞り込みが行えます。
  - 予算に合わせて絞り込みが行えます。
- ログインすることで、以下の機能が利用できます。
  - いつか行きたい、行ってよかったお店をお気に入りに登録出来ます。 
  - コメントが投稿出来、以前訪問したユーザーの意見が見れます。

## Road map
- 飲食店オーナー向けの管理画面。
- 飲食店オーナーの課金度合いによって表示確率を変動させる。
- 飲食店オーナーによる飲食店の自己PR項目。

# 注目して頂きたい部分

- 開発環境での問題をnginx、Vagrant等を用いて柔軟に解決する問題解決能力。
- Frontend、Backendを切り分け、Dockerを利用してマイクロサービスアーキテクチャを実現。
- DockerComposeを用いて開発環境構築・自動テストをしている。
- ECS/ECRを用いて本番環境を設計・構築、常時SSL通信をしている。
- Frontendにて、Nuxt.jsを用いてSPAを実現。
- UIUX・デザインにこだわり、より少ない導線でのサービス提供の実現。
- レスポンシブデザインに対応している。
- 外部API（HotPepperAPI、GoogleAPI、firebase）を用いて機能を実現している。
- CircleCIを用いて自動テスト・自動デプロイをしている。
- terraformを用いてIaCを実現している。

# Architecture
![インフラ構成](https://user-images.githubusercontent.com/35006561/90001148-04314b80-dccc-11ea-9497-44a40d9bd6d5.png)

# Technology used
## Development Environment
- Docker
- DockerCompose
- nginx
- openssl <br>
> 位置情報取得の際に、ChromeだとSSL化しなければ取得出来ないため、nginxを追加・対処しました。
- Vagrant（ubuntu） <br>
> PCのCPU・メモリ・バッテリーに限界が来たため、仮想環境にて開発。 <br>
> Docker hyperkitがCPU100%に張り付くバグがあったため、対処しました。


## Infrastructure
- ECS/ECR
- EC2
- ALB
- RDS for MySQL
- Route53
- Certificate Manager
- VPC
- CloudWatch
- IAM
- Auto Scaling

## Infrastructure As Code
- terraform
- terraforming
- terraformer

## CI/CD
- CircleCI

## Frontend
- node:12.5.0
- Vue.js
- Nuxt.js
- Vuetify
- firebase/auth
- axios
- dotenv
- nuxt/auth,axios,dotenv,proxy
- lodash
- loaders.css
- vee-validate
- vuex-persistendstate
- es-lint
- babel-eslint
- prettier
- vue-server-renderer
- material-design-icons-iconfont

## Backend
- ruby:2.6.3
- rails:5.2.4.3
- MySQL
- puma
- rubocop
- dotenv-rails
- rspec-rails
