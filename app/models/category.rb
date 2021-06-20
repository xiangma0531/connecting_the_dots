class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '考え事'}, { id: 2, name: '読書'},
    { id: 3, name: '日常生活の中での気づき'}, { id: 4, name: '仕事の中での気づき'},
    { id: 5, name: '趣味の中での気づき'}, { id: 6, name: '各種メディアから得たことについて'},
    { id: 7, name: 'その他'}
  ]
  include ActiveHash::Associations
  has_many :dots
end