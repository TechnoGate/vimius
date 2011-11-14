module SubmodulesDefinition
  def self.included(base)
    base.class_eval <<-END, __FILE__, __LINE__ + 1
      let :submodules do
        {
          "submodules" => {
            "pathogen" => {
              "path"  => "vimius/vim/core/pathogen",
              "group" => "core",
            },
            "tlib" => {
              "path"  => "vimius/vim/tools/tlib",
              "group" => "tools",
              "dependencies" => ["pathogen"],
            },
            "github" => {
              "path"  => "vimius/vim/tools/github",
              "group" => "tools",
              "dependencies" => ["pathogen"],
            },
            "command-t" => {
              "path"  => "vimius/vim/tools/command-t",
              "group" => "tools",
              "dependencies" => ["tlib"],
            },
          },
        }
      end

      let :expected_submodules do
        [
          {
            "path"  => "vimius/vim/core/pathogen",
            "group" => "core",
            "name"  => "pathogen",
          },
          {
            "path"  => "vimius/vim/tools/tlib",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "tlib",
          },
          {
            "path"  => "vimius/vim/tools/github",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "github",
          },
          {
            "path"  => "vimius/vim/tools/command-t",
            "group" => "tools",
            "dependencies" => ["tlib"],
            "name"  => "command-t",
          },
        ]
      end

      let :expected_active_submodules do
        [
          {
            "path"  => "vimius/vim/core/pathogen",
            "group" => "core",
            "name"  => "pathogen",
          },
          {
            "path"  => "vimius/vim/tools/tlib",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "tlib",
          },
          {
            "path"  => "vimius/vim/tools/github",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "github",
          },
        ]
      end

      let :expected_inactive_submodules do
        [
          {
            "path"  => "vimius/vim/tools/command-t",
            "group" => "tools",
            "dependencies" => ["tlib"],
            "name"  => "command-t",
          },
        ]
      end

      let :submodules_by_group do
        {
          "core" =>
          [
            {
              "path"  => "vimius/vim/core/pathogen",
              "group" => "core",
              "name"  => "pathogen",
            },
          ],
          "tools" =>
          [
            {
              "path"  => "vimius/vim/tools/tlib",
              "group" => "tools",
              "dependencies" => ["pathogen"],
              "name" => "tlib",
            },
            {
              "path"  => "vimius/vim/tools/github",
              "group" => "tools",
              "dependencies" => ["pathogen"],
              "name" => "github",
            },
            {
              "path"  => "vimius/vim/tools/command-t",
              "group" => "tools",
              "dependencies" => ["tlib"],
              "name" => "command-t",
            },
          ],
        }
      end

      let :submodules_by_name do
        {
          "pathogen" => {
            "path"  => "vimius/vim/core/pathogen",
            "group" => "core",
            "name"  => "pathogen",
          },
          "tlib" => {
            "path"  => "vimius/vim/tools/tlib",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "tlib",
          },
          "github" => {
            "path"  => "vimius/vim/tools/github",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "github",
          },
          "command-t" => {
            "path"  => "vimius/vim/tools/command-t",
            "group" => "tools",
            "dependencies" => ["tlib"],
            "name"  => "command-t",
          },
        }
      end

      let :active_by_group do
        {
          "core" =>
          [
            {
              "path"  => "vimius/vim/core/pathogen",
              "group" => "core",
              "name"  => "pathogen",
            },
          ],
          "tools" =>
          [
            {
              "path"  => "vimius/vim/tools/tlib",
              "group" => "tools",
              "dependencies" => ["pathogen"],
              "name" => "tlib",
            },
            {
              "path"  => "vimius/vim/tools/github",
              "group" => "tools",
              "dependencies" => ["pathogen"],
              "name" => "github",
            },
          ],
        }
      end

      let :active_by_name do
        {
          "pathogen" => {
            "path"  => "vimius/vim/core/pathogen",
            "group" => "core",
            "name"  => "pathogen",
          },
          "tlib" => {
            "path"  => "vimius/vim/tools/tlib",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "tlib",
          },
          "github" => {
            "path"  => "vimius/vim/tools/github",
            "group" => "tools",
            "dependencies" => ["pathogen"],
            "name"  => "github",
          },
        }
      end

      let :inactive_by_group do
        {
          "tools" =>
          [
            {
              "path"  => "vimius/vim/tools/command-t",
              "group" => "tools",
              "dependencies" => ["tlib"],
              "name" => "command-t",
            },
          ],
        }
      end

      let :inactive_by_name do
        {
          "command-t" => {
            "path"  => "vimius/vim/tools/command-t",
            "group" => "tools",
            "dependencies" => ["tlib"],
            "name"  => "command-t",
          },
        }
      end
    END
  end
end

RSpec.configure do |config|
  config.include SubmodulesDefinition
end
