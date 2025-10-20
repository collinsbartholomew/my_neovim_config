-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.setup(config)
  config = config or {}
  
  -- Java Format command
  vim.api.nvim_create_user_command('JavaFormat', function()
    -- Check if google-java-format is available
    if vim.fn.executable('google-java-format') == 1 then
      vim.cmd('silent !google-java-format -i %')
      vim.notify("Formatted with google-java-format", vim.log.levels.INFO)
    else
      -- Try build tool specific formatting
      if vim.fn.filereadable('build.gradle') == 1 or vim.fn.filereadable('build.gradle.kts') == 1 then
        vim.cmd('belowright new | terminal ./gradlew spotlessApply')
      elseif vim.fn.filereadable('pom.xml') == 1 then
        vim.cmd('belowright new | terminal mvn spotless:apply')
      else
        vim.notify("No formatter found. Install google-java-format or configure spotless plugin.", vim.log.levels.WARN)
      end
    end
  end, {})

  -- Maven Build command
  vim.api.nvim_create_user_command('MavenBuild', function()
    if vim.fn.filereadable('pom.xml') == 1 then
      vim.cmd('belowright new | terminal mvn clean install')
    else
      vim.notify("No pom.xml found in current directory", vim.log.levels.WARN)
    end
  end, {})

  -- Gradle Build command
  vim.api.nvim_create_user_command('GradleBuild', function()
    local gradle_wrapper = 'gradlew'
    if vim.fn.filereadable(gradle_wrapper) == 0 then
      gradle_wrapper = 'gradle'
    end
    
    if vim.fn.executable(gradle_wrapper) == 1 then
      vim.cmd('belowright new | terminal ' .. gradle_wrapper .. ' build')
    else
      vim.notify("Gradle not found", vim.log.levels.WARN)
    end
  end, {})

  -- Run Tests command
  vim.api.nvim_create_user_command('RunTests', function()
    if vim.fn.filereadable('build.gradle') == 1 or vim.fn.filereadable('build.gradle.kts') == 1 then
      local gradle_wrapper = './gradlew'
      if vim.fn.executable(gradle_wrapper) == 0 then
        gradle_wrapper = 'gradle'
      end
      vim.cmd('belowright new | terminal ' .. gradle_wrapper .. ' test')
    elseif vim.fn.filereadable('pom.xml') == 1 then
      vim.cmd('belowright new | terminal mvn test')
    else
      vim.notify("No build file found", vim.log.levels.WARN)
    end
  end, {})

  -- Java Run command
  vim.api.nvim_create_user_command('JavaRun', function()
    local main_class = vim.fn.input('Main class: ', '', 'file')
    if main_class ~= '' then
      vim.cmd('belowright new | terminal java ' .. main_class)
    end
  end, {})

  -- JFR commands
  vim.api.nvim_create_user_command('StartJFR', function()
    vim.notify("JFR profiling requires JVM flags. Add -XX:+FlightRecorder -XX:StartFlightRecording=...", vim.log.levels.INFO)
  end, {})

  vim.api.nvim_create_user_command('StopJFR', function()
    vim.notify("JFR profiling requires JVM flags. Add -XX:+FlightRecorder -XX:StartFlightRecording=...", vim.log.levels.INFO)
  end, {})

  -- Async Profiler command
  vim.api.nvim_create_user_command('StartAsyncProfiler', function()
    vim.notify("Install async-profiler and use: java -agentpath:/path/to/libasyncProfiler.so=start,...", vim.log.levels.INFO)
  end, {})

  -- Package analysis
  vim.api.nvim_create_user_command('JavaPackageAnalyze', function()
    if vim.fn.executable('jdeps') == 1 then
      vim.cmd('belowright new | terminal jdeps ' .. vim.fn.expand('%'))
    else
      vim.notify("jdeps not found. Install JDK with jdeps command.", vim.log.levels.WARN)
    end
  end, {})

  -- Coverage command
  vim.api.nvim_create_user_command('JavaCoverage', function()
    vim.notify("Use JaCoCo Maven/Gradle plugin for coverage reports", vim.log.levels.INFO)
  end, {})

  -- Integrate with conform.nvim for formatting
  local conform_status, conform = pcall(require, "conform")
  if conform_status then
    -- We don't add to formatters_by_ft here because we want to keep it optional
    -- User can add this to their conform setup:
    -- formatters_by_ft = {
    --   java = { "google_java_format" },
    -- }
  end
end

return M