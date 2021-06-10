class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '日々の授業'}, { id: 2, name: '家庭学習'},
    { id: 3, name: '模試'}, { id: 4, name: '総合学習'},
    { id: 5, name: 'ボランティア活動'}, { id: 6, name: '検定等受検'},
    { id: 7, name: '部活動'}, { id: 8, name: '日常の気づき'},
    { id: 9, name: '趣味の中で'}, { id: 10, name: 'その他'}
  ]
  include ActiveHash::Associations
  has_many :dots
end