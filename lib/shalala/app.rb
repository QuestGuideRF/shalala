module Shalala
  class App
    def self.call(env)
      new.call(env)
    end
    def call(env)
      commit = resolved_commit
      branch = resolved_branch
      if commit
        body = "фиксация: #{commit}\nветвь: #{branch}"
        [200, { "content-type" => "text/plain" }, [body]]
      else
        [404, { "content-type" => "text/plain" }, ["Не найдено"]]
      end
    end
    private
    def resolved_commit
      env_commit = ENV["GIT_COMMIT"]
      return env_commit if env_commit && !env_commit.empty?
      return current_git_commit if development_environment?
      nil
    end
    def resolved_branch
      env_branch = ENV["GIT_BRANCH"]
      return env_branch if env_branch && !env_branch.empty?
      current_git_branch
    end
    def development_environment?
      (ENV["RACK_ENV"] || "development") == "development"
    end
    def current_git_commit
      sha = `git rev-parse HEAD`.strip
      $?.success? ? sha : nil
    rescue StandardError
      nil
    end
    def current_git_branch
      branch = `git branch --show-current`.strip
      return branch if $?.success? && !branch.empty?
      fallback = `git rev-parse --abbrev-ref HEAD`.strip
      $?.success? ? fallback : nil
    rescue StandardError
      nil
    end
  end
end