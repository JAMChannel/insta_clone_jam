puts 'Start inserting seed "posts" ...'
# seedsファイルで「require './db/seeds/users'」を先に記載しているので、アソシエーションを使用してpostを作成できる。
User.limit(10).each do |user|
  post = user.posts.create(
    body: Faker::Movies::StarWars.quote,
    remote_images_urls: %w[https://picsum.photos/350/350/?random https://picsum.photos/350/350/?random]
  )
  puts "post#{post.id} has created!"
end