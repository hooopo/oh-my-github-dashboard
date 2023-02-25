class VercelEnv
  def self.cat
    evidence_setting = File.read(Rails.root.join("../.evidence/template/evidence.settings.json"))
    evidence_setting = JSON.parse(evidence_setting)
    output = <<~EOF
    DATABASE=mysql
    MYSQL_HOST=#{evidence_setting["credentials"]["host"]}
    MYSQL_DATABASE=#{evidence_setting["credentials"]["database"]}
    MYSQL_USER=#{evidence_setting["credentials"]["user"]}
    MYSQL_PASSWORD=#{evidence_setting["credentials"]["password"]}
    MYSQL_PORT=#{evidence_setting["credentials"]["port"]}
    MYSQL_SSL=#{evidence_setting["credentials"]["ssl"]}
    EOF
  end
end