class Micropost < ActiveRecord::Base
  belongs_to :user #models/user.rbのhas_many :micropostsに対応
  mount_uploader :picture, PictureUploader #追加したカラム名をここに指定
  validates :user_id, presence: true #空白禁止
  validates :content, presence: true, length: { maximum: 140 } #空白禁止, 140字まで
  validate  :picture_size #下記
  
  private
    # アップロード画像のサイズを検証する
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end