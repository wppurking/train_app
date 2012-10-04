# -*- encoding : utf-8 -*-

# 不记得我第一次弄个 rake 测试是什么时候了, 那个时候我使用的是 .rb 结尾的, 应该也是可行的吧,
# 但在这个 lib/tasks 目录下一定需要将文件后缀写成 .rake 才可以.
# --- 补充, 经过在空白路径运行 rake 得之, 我上次应该是编写了一个 rakefile.rb 文件 - -||
# [No Rakefile found (looking for: rakefile, Rakefile, rakefile.rb, Rakefile.rb)]
namespace :db do

  desc "为开发环境添加测试数据"
  # 在 Rails 中, 如果要使用 Model 进行操作, 此 task 需要依赖 rails 提供的 :environment task 来提供运行环境
  # 答案从 http://jasonseifer.com/2010/04/06/rake-tutorial 这里
  # 和 http://railscasts.com/episodes/66-custom-rake-tasks 来
  # 利用 RubyMine 打开 :environment task, 原来这个 task 是在 railties gem 的 applicatioin.rb 文件中
  # 简单来说就是将 config/environments 中的第一个环境文件引入进来
  task populate: :environment do
    User.create!(name: "wyatt", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar")
  end

end

desc "测试 rake 不需要的 rails environment 的 task"
task :hello do
  puts "hello world"
end

desc "测试 rake 中的 rake 依赖"
task ask: :hello do
  puts "after hello, ask"
end
