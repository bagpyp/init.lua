-- Test custom modules (run.lua, docker.lua)

describe("Custom Modules", function()
  describe("Run Configuration Module", function()
    local run_ok, run = pcall(require, "config.run")
    
    it("should load run module", function()
      assert.is_true(run_ok, "Run module failed to load")
    end)

    if run_ok then
      it("should have configs array", function()
        assert.is_not_nil(run.configs)
        assert.is_true(type(run.configs) == "table")
      end)

      it("should have default run configurations", function()
        assert.is_true(#run.configs > 0, "No run configurations defined")
        
        -- Check structure of configs
        for _, config in ipairs(run.configs) do
          assert.is_not_nil(config.name, "Config missing name")
          assert.is_not_nil(config.cmd, "Config missing command")
          assert.is_not_nil(config.type, "Config missing type")
        end
      end)

      it("should have navigation functions", function()
        assert.is_function(run.next)
        assert.is_function(run.prev)
        assert.is_function(run.toggle)
        assert.is_function(run.show)
        assert.is_function(run.hide)
        assert.is_function(run.run_current)
      end)

      it("should handle current index", function()
        assert.is_not_nil(run.current_index)
        assert.is_true(type(run.current_index) == "number")
        assert.is_true(run.current_index >= 1)
        assert.is_true(run.current_index <= #run.configs)
      end)

      it("should cycle through configs", function()
        local initial = run.current_index
        run.next()
        local after_next = run.current_index
        
        if #run.configs > 1 then
          assert.are_not.equal(initial, after_next)
        end
        
        -- Cycle back to original position
        -- We need to cycle #configs - 1 more times since we already did one next()
        for _ = 1, #run.configs - 1 do
          run.next()
        end
        assert.are.equal(initial, run.current_index)
      end)
    end
  end)

  describe("Docker Module", function()
    local docker_ok, docker = pcall(require, "config.docker")
    
    it("should load docker module", function()
      assert.is_true(docker_ok, "Docker module failed to load")
    end)

    if docker_ok then
      it("should have toggle function", function()
        assert.is_function(docker.toggle)
      end)

      it("should have show/hide functions", function()
        assert.is_function(docker.show)
        assert.is_function(docker.hide)
      end)

      it("should have refresh function", function()
        assert.is_function(docker.refresh)
      end)

      it("should track visibility state", function()
        assert.is_not_nil(docker.is_visible)
        assert.is_boolean(docker.is_visible)
      end)

      it("should handle buffer and window", function()
        -- These might be nil initially
        assert.is.truthy(docker.buf == nil or type(docker.buf) == "number")
        assert.is.truthy(docker.win == nil or type(docker.win) == "number")
      end)
    end
  end)

  describe("Performance Module", function()
    it("should have disabled built-in plugins", function()
      local disabled = {
        "netrw", "gzip", "zip", "tar", "matchit", "matchparen"
      }
      
      for _, plugin in ipairs(disabled) do
        assert.are.equal(1, vim.g["loaded_" .. plugin], 
          plugin .. " should be disabled")
      end
    end)

    it("should have disabled providers", function()
      assert.are.equal(0, vim.g.loaded_python3_provider)
      assert.are.equal(0, vim.g.loaded_ruby_provider)
      assert.are.equal(0, vim.g.loaded_perl_provider)
      assert.are.equal(0, vim.g.loaded_node_provider)
    end)
  end)
end)