require "spec_helper"
require "rack/test"
require "shalala"
RSpec.describe "Конечная точка фиксации" do
  include Rack::Test::Methods
  def app
    Shalala::App.new
  end
  around do |example|
    original_commit = ENV["GIT_COMMIT"]
    original_branch = ENV["GIT_BRANCH"]
    original_rack_env = ENV["RACK_ENV"]
    example.run
    ENV["GIT_COMMIT"] = original_commit
    ENV["GIT_BRANCH"] = original_branch
    ENV["RACK_ENV"] = original_rack_env
  end
  it "доступен по смонтированному пути" do
    ENV["GIT_COMMIT"] = "deadbeef"
    ENV["GIT_BRANCH"] = "main"
    ENV["RACK_ENV"] = "production"
    get "/"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("совершить: Deadbeef\nветвь: основной")
  end
  it "возвращает GIT_COMMIT в средах, не связанных с разработкой" do
    ENV["GIT_COMMIT"] = "cafebabe"
    ENV["GIT_BRANCH"] = "release/1.2.3"
    ENV["RACK_ENV"] = "production"
    get "/"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("зафиксировать: cafebabe\nветвь: Release/1.2.3")
  end
  it "возвраты не найдены, если GIT_COMMIT не установлен вне разработки" do
    ENV.delete("GIT_COMMIT")
    ENV.delete("GIT_BRANCH")
    ENV["RACK_ENV"] = "production"
    get "/"
    expect(last_response.status).to eq(404)
  end
  it "возвращает GIT_COMMIT в разработке, если установлен" do
    ENV["GIT_COMMIT"] = "beadfeed"
    ENV["GIT_BRANCH"] = "feature/shiny"
    ENV["RACK_ENV"] = "development"
    get "/"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("commit: beadfeed\nbranch: Feature/блестящий")
  end
  it "возвращает текущий коммит git в разработке, если GIT_COMMIT не установлен" do
    ENV.delete("GIT_COMMIT")
    ENV.delete("GIT_BRANCH")
    ENV["RACK_ENV"] = "development"
    allow_any_instance_of(Shalala::App)
      .to receive(:current_git_commit)
      .and_return("123abc")
    allow_any_instance_of(Shalala::App)
      .to receive(:current_git_branch)
      .and_return("main")
    get "/"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("совершить: 123abc\nветвь: основная")
  end
end