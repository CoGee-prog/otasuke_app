# おたスケ  
草野球のスケジュール管理や出欠確認、対戦相手検索ができるサイトです.  
対戦相手検索では、指定した日時のスケジュールが空いているチームを検索することができます。  
レスポンシブ対応しているため、スマホからもご確認いただけます。  
https://otasuke-app.com/  

<img width="1426" alt="スクリーンショット 2021-10-18 23 32 08" src="https://user-images.githubusercontent.com/80146722/137755877-c5d5c167-0a31-4ed9-b36b-72eeed4c637f.png">  
![おたスケ スケジュール管理](https://user-images.githubusercontent.com/80146722/138393189-716bfb80-e346-496f-8ac7-0dabdbdb5248.gif)

# 使用技術  
* Ruby 2.6.7  
* Ruby on Rails 6.1.3  
* MySQL 8.0  
* Nginx  
* Unicorn  
* AWS  
	* VPC  
	* EC2  
	* S3  
	* SES  
	* Route53  
	* ELB  
	* Certificate Maneger  
* Docker/Docker-compose  
* CircleCI CI/CD  
* Capistrano3  
* RSpec  
* Rubocop  

# ER図  
![おたスケ ER図 drawio](https://user-images.githubusercontent.com/80146722/137756606-f43ce450-4778-4704-b003-492531202657.png)

# インフラ構成図  
![おたスケ インフラ構成図 drawio](https://user-images.githubusercontent.com/80146722/137757056-4329a93c-6c62-40bd-9b29-d84888f428c7.png)

## CircleCI CI/CD  
* GitHubへのpush時にRubocopとRSpecが自動で実行され、コードの品質が保証されるようにしています。  
* masterブランチへのマージ時にRubocopとRSpecが成功した場合、Capistranoが実行されEC2へ自動デプロイされます。  

# 機能一覧  
* ユーザー登録、ログイン機能  
	* パスワードを忘れてログインできなくなった際のパスワード変更機能  
* ユーザープロフィール編集機能
* チーム作成機能
	* チームプロフィール画像設定機能
* 所属チーム検索機能
	* 所属申請機能
* チーム切り替え機能
* チーム管理者機能
	* 試合リクエスト一覧機能
	* 所属リクエスト一覧機能
	* メンバー一覧機能  
	* チーム編集機能
	* チーム削除機能
* スケジュール管理機能  
	* スケジュール登録機能
	* スケジュール編集機能
	* スケジュール削除機能
	* 出欠回答機能  
	* 出欠合計計算機能  
* 対戦相手検索機能  
	* 指定した日時が空いているチーム検索機能
	* 活動エリア検索機能
	* チームレベル検索機能  
	* スケジュール詳細閲覧機能
* 対戦申込機能  
	* 連絡先、コメント送信機能
	* 画像送信機能(QRコード等)

# テスト  
* RSpec  
	* 単体テスト(model)  
	* 機能テスト(request)  
	* 統合テスト(system)  
