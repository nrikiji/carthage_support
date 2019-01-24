require "carthage_support"
require "thor"
require "hashie"
require "xcodeproj"

BUILD_PHASE_NAME = "Carthage Run Script"

def shell_script_phase?(build_phase)
  if build_phase.isa != "PBXShellScriptBuildPhase"
    false
  elsif build_phase.name != BUILD_PHASE_NAME
    false
  else
    true
  end
end

module CarthageSupport
  class CLI < Thor
    desc "{usage}", "{description}"
    def setup()
      begin
        
        repos = []
        frameworks = []
        project = nil
        
        yaml = Hashie::Mash.load("../work/carthage.yml")
        yaml.each_with_index do |obj,i|
          if obj.first == "project_path"
            project = Xcodeproj::Project.open(obj.last)
          else
            repos.push(obj.first)
            obj.last.each do |fw,j|
              frameworks.push(fw)
            end
          end
        end

        if project.nil?
          raise "projectfile is not"
        end

        ## Framework Search Paths
        project.targets.each do |target|
          ["Debug", "Release"].each do |config|
            paths = target.build_settings(config)["FRAMEWORK_SEARCH_PATHS"]
            path_carthage = "$(PROJECT_DIR)/Carthage/Build/iOS"
            if paths.nil?
              paths = ['$(inherited)', path_carthage]
            else
              unless paths.include?(path_carthage)
                paths.push(path_carthage)
              end
            end
            target.build_settings(config)["FRAMEWORK_SEARCH_PATHS"] = paths
          end
        end

        ## Run Script
        project.targets.each do |target|
          exists_build_phase = false
          target.build_phases.each do |build_phase|
            if shell_script_phase?(build_phase)
              exists_build_phase = true
            end
          end
          if !exists_build_phase
            build_phase = project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
            build_phase.name = BUILD_PHASE_NAME
            build_phase.shell_path = "/bin/sh"
            build_phase.shell_script = "/usr/local/bin/carthage copy-frameworks\n"
            build_phase.input_paths = []
            target.build_phases << build_phase
          end
        end

        project.targets.each do |target|
          target.build_phases.each do |build_phase|
            if shell_script_phase?(build_phase)
              frameworks.each do |framework|
                framework_path = "$(SRCROOT)/Carthage/Build/iOS/" + framework
                unless build_phase.input_paths.include?(framework_path)
                  build_phase.input_paths.push(framework_path)
                end
              end
            end
          end
        end

        ## Linked Frameworks and Libraries
        project.targets.each do |target|
          target.build_phases.each do |build_phase|
            if build_phase.isa == "PBXFrameworksBuildPhase"
              frameworks.each do |framework|
                framework_ref = project.new(Xcodeproj::Project::Object::PBXFileReference)
                framework_ref.name = framework
                framework_ref.path = "Carthage/Build/iOS/" + framework

                count = build_phase.files_references.count{|ref| ref.name == framework && framework_ref.path == ref.path }
                if count == 0
                  build_phase.add_file_reference(framework_ref, false)
                end
              end
            end
          end
        end

        project.save()
        
      rescue => e
        p e
      end
      
    end
  end
end
