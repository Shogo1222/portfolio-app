# - Bischierge -

**Bistro + Concierge = Bischierge** <br>
近くの飲食店をランダムで検索出来ることができるアプリケーションです。<br>
「今日、何食べる？」を、**Simple, Smart and Smooth User Flow**で解決する事がコンセプトです。<br><br>
[https://www.bischierge.work/](https://www.bischierge.work/)

### PC view
![ezgif com-video-to-gif (1)](https://user-images.githubusercontent.com/35006561/90373338-bc843880-e0ac-11ea-8155-eeb02abae118.gif)

### SP view
![ezgif com-optimize](https://user-images.githubusercontent.com/35006561/90375215-9c09ad80-e0af-11ea-97c6-a74e5661bfd2.gif)

## Target users
- これから「何を食べようか」と悩む人
- これから恋人や友人と食事に行く際に、何処に行くか決められない人
- グルメサイトを見て、情報が多すぎて何処に行くべきか決められない人

## Functions
- 飲食店検索機能
  - 飲食店をランダムで9件表示します。
  - 気分に合わせて洋食・和食・中華などの絞り込みが行えます。
  - 予算に合わせて絞り込みが行えます。
  - 位置情報を利用して絞り込みが行えます。
  - マップを指定して絞り込みが行えます。
- コメント機能
  - コメントが投稿・削除が出来ます。
  - コメントへのイイね・削除が出来ます。
- お気に入り機能
  - いつか行きたい、行ってよかったお店をお気に入りに登録・削除出来ます。 
  - 過去にしたお気に入りを全て表示出来ます。
- 訪問機能
  - 行ったことがあるお店を登録・削除出来ます。 
  - 過去に行ったことがあるお店を全て表示出来ます。
- プロフィール機能
  - ユーザーを登録、プロフィールを編集・削除出来ます。
  - プロフィール画面で、直近お気に入り・行ったことがある・コメントしたお店を表示出来ます。
  - プロフィール画面で、直近行ったことがあるお店のマップを表示出来ます。
- タグ機能
  - プロフィールで登録したユーザーにタグ情報を付与出来ます。
  - 飲食店に紐づけられたタグ情報を検索出来ます。
  - ログインユーザー以外が過去に入力したタグを入力時にレコメンド出来ます。
  - 選択飲食店以外の他のユーザーが過去に入力したタグを入力時にレコメンド出来ます。
- 検索機能
  - ユーザーに紐づけられたタグ情報を検索出来ます。
  - 飲食店に紐づけられたタグ情報を検索出来ます。
  - ユーザーネームからユーザーを検索出来ます。
- フォロー機能
  - ユーザー同士でフォロー・フォロー解除出来ます。
  - 相互フォローだった場合、アイコンがつきます。
  - フォローしている人が直近お気に入りしたお店りがレコメンドされます。
  - フォローしている人が直近訪れたお店がレコメンドされます。
- インビテーション機能
  - フォローしているユーザーに招待状を送れます。
- 通知機能
  - フォローされていると、プロフィールアイコンに新着バッジがつきます。
  - プロフィールページ閲覧時にリアルタイムで通知が消滅します。
  - インビテーションが来ていると、インビテーションアイコンに新着バッジがつきます。
  - インビテーションページ閲覧時にリアルタイムで通知が消滅します。
 

# Selling points

- 開発環境での問題をnginx、Vagrant等を用いて柔軟に解決する問題解決能力。
- Frontend、Backendを切り分け、Dockerを利用して疎結合のシステムを実現。
- DockerComposeを用いて開発環境構築・自動テストをしている。
- ECS/ECRを用いて本番環境を設計・構築、常時SSL通信をしている。
- Frontendにて、Nuxt.jsを用いてSPAを実現。
- UIUX・デザインにこだわり、より少ない導線・心地よい使用感でのサービス提供の実現。
- レスポンシブデザインに対応している。
- 外部API（HotPepperAPI、GoogleAPI、firebase）を用いて機能を実現している。
- CircleCIを用いて自動テスト・自動デプロイをしている。
- terraformを用いてIaCを実現している。

# Architecture
![インフラ構成](https://user-images.githubusercontent.com/35006561/90375824-703af780-e0b0-11ea-8d43-7edfb322e6c1.png)

# ER
![er](https://user-images.githubusercontent.com/35006561/91324326-e6500480-e7fc-11ea-9703-1f5725650c3c.png)


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
- IAM
- Auto Scaling
- S3

## Infrastructure As Code
- terraform
- terraforming
- terraformer

## CI/CD
- CircleCI

## Frontend
- node:12.5.0
- Vue.js:2.6.11
- Nuxt.js:2.12.2
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
- vue2-google-maps

## Backend
- ruby:2.6.3
- rails:5.2.4.3
- MySQL:5.7.30
- puma
- rubocop
- dotenv-rails
- rspec-rails
- carrierwave
- fog-aws

## IDE
- ATOM
