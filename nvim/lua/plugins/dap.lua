return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
        "nvim-neotest/nvim-nio",
    },
    keys = {
        {
            "<leader>du",
            function()
                require("dapui").toggle()
            end,
            desc = "DAP: Toggle UI",
        },
        {
            "<leader>db",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "DAP: Toggle breakpoint",
        },
        {
            "<leader>dd",
            function()
                require("dap-go").debug_test()
            end,
            desc = "DAP (Go): Debug test",
        },
        {
            "<leader>dl",
            function()
                require("dap-go").debug_last_test()
            end,
            desc = "DAP (Go): Debug last test",
        },
        {
            "<leader>dc",
            function()
                require("dap").continue()
            end,
            desc = "DAP: Continue",
        },
        {
            "<leader>dr",
            function()
                require("dap").run_to_cursor()
            end,
            desc = "DAP: Run to cursor",
        },
        {
            "<leader>dt",
            function()
                require("dap").terminate()
            end,
            desc = "DAP: Terminate",
        },
        {
            "<right>",
            function()
                require("dap").step_into()
            end,
            desc = "DAP: Step into",
        },
        {
            "<left>",
            function()
                require("dap").step_out()
            end,
            desc = "DAP: Step out",
        },
        {
            "<down>",
            function()
                require("dap").step_over()
            end,
            desc = "DAP: Step over",
        },
        {
            "<up>",
            function()
                require("dap").restart_frame()
            end,
            desc = "DAP: Restart frame",
        },
    },
    config = function()
        require("dap-go").setup()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
    end,
}
