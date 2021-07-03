require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "アカウント有効化テスト" do
    let(:mail) { UserMailer.account_activation(user) }
    let(:user) { FactoryBot.create(:user) }

    it "ヘッダーのレンダリング" do
      expect(mail.subject).to eq("おたスケ メールアドレス認証")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@otasuke.com"])
    end

    it "本文のレンダリング" do
      expect(mail.text_part.body.encoded).to match(user.name)
      expect(mail.html_part.body.encoded).to match(user.name)
      expect(mail.text_part.body.encoded).to match(user.activation_token)
      expect(mail.html_part.body.encoded).to match(user.activation_token)
      expect(mail.text_part.body.encoded).to match(CGI.escape(user.activation_token))
      expect(mail.html_part.body.encoded).to match(CGI.escape(user.activation_token))
    end
  end

  xdescribe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
