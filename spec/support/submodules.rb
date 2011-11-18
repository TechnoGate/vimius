module SubmodulesDefinition
  def self.included(base)
    base.class_eval <<-END, __FILE__, __LINE__ + 1
      let :submodules do
        {
          "submodules" => {
            "core" => {
              "pathogen" => nil,
            },
            "tools" => {
              "tlib" => {
                "dependencies" => ["pathogen"],
              },
              "github" => {
                "dependencies" => ["pathogen"],
              },
              "command-t" => {
                "dependencies" => ["tlib"],
              },
            },
          },
        }
      end

      let :expected_submodules do
        [
          {
            "name"  => "pathogen",
            "description" => "",
            "group" => "core",
            "path"  => "vimius/vim/core/pathogen",
            "dependencies" => []
          },
          {
            "name"  => "tlib",
            "description" => "",
            "group" => "tools",
            "path"  => "vimius/vim/tools/tlib",
            "dependencies" => ["pathogen"],
          },
          {
            "name"  => "github",
            "description" => "",
            "group" => "tools",
            "path"  => "vimius/vim/tools/github",
            "dependencies" => ["pathogen"],
          },
          {
            "name"  => "command-t",
            "description" => "",
            "group" => "tools",
            "path"  => "vimius/vim/tools/command-t",
            "dependencies" => ["tlib"],
          },
        ]
      end

      let :expected_active_submodules do
        [
          {
            "name"  => "pathogen",
            "description" => "",
            "group" => "core",
            "path"  => "vimius/vim/core/pathogen",
            "dependencies" => [],
          },
          {
            "name"  => "tlib",
            "description" => "",
            "group" => "tools",
            "path"  => "vimius/vim/tools/tlib",
            "dependencies" => ["pathogen"],
          },
          {
            "name"  => "github",
            "description" => "",
            "group" => "tools",
            "path"  => "vimius/vim/tools/github",
            "dependencies" => ["pathogen"],
          },
        ]
      end

      let :expected_inactive_submodules do
        [
          {
            "name"  => "command-t",
            "description" => "",
            "group" => "tools",
            "path"  => "vimius/vim/tools/command-t",
            "dependencies" => ["tlib"],
          },
        ]
      end

      let :submodules_by_group do
        {
          "core" =>
          [
            {
              "name"  => "pathogen",
              "description" => "",
              "group" => "core",
              "path"  => "vimius/vim/core/pathogen",
              "dependencies" => [],
            },
          ],
          "tools" =>
          [
            {
              "name" => "tlib",
              "description" => "",
              "group" => "tools",
              "path"  => "vimius/vim/tools/tlib",
              "dependencies" => ["pathogen"],
            },
            {
              "name" => "github",
              "description" => "",
              "group" => "tools",
              "path"  => "vimius/vim/tools/github",
              "dependencies" => ["pathogen"],
            },
            {
              "name" => "command-t",
              "description" => "",
              "group" => "tools",
              "path"  => "vimius/vim/tools/command-t",
              "dependencies" => ["tlib"],
            },
          ],
        }
      end

      let :active_by_group do
        {
          "core" =>
          [
            {
              "name"  => "pathogen",
              "description" => "",
              "group" => "core",
              "path"  => "vimius/vim/core/pathogen",
              "dependencies" => [],
            },
          ],
          "tools" =>
          [
            {
              "name" => "tlib",
              "description" => "",
              "group" => "tools",
              "path"  => "vimius/vim/tools/tlib",
              "dependencies" => ["pathogen"],
            },
            {
              "name" => "github",
              "description" => "",
              "group" => "tools",
              "path"  => "vimius/vim/tools/github",
              "dependencies" => ["pathogen"],
            },
          ],
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
              "description" => "",
            },
          ],
        }
      end
    END
  end
end

RSpec.configure do |config|
  config.include SubmodulesDefinition
end
