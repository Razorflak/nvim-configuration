-- Fonction pour vérifier si le dossier .git existe
local function check_git_folder()
    local git_dir = vim.fn.getcwd() .. "/.git"
    return vim.fn.isdirectory(git_dir) == 1
end

-- Fonction pour vérifier et créer le dossier "pen"
local function ensure_pen_folder()
    local pen_dir = vim.fn.getcwd() .. "/pen"
    if vim.fn.isdirectory(pen_dir) ~= 1 then
        vim.fn.mkdir(pen_dir, "p")
    end
end

-- Fonction pour ouvrir le fichier notes.md dans un nouvel onglet
local function open_notes_md()
    local notes_md = vim.fn.getcwd() .. "/pen/notes.md"
    if vim.fn.filereadable(notes_md) == 1 then
        vim.cmd(":tab drop " .. notes_md)
    else
        vim.fn.writefile({}, notes_md)
        vim.cmd(":tab edit " .. notes_md)
    end
end
-- Fonction pour vérifier si le dossier "pen" est exclu dans .git/info/exclude
local function is_pen_excluded()
    local exclude_file = vim.fn.getcwd() .. "/.git/info/exclude"
    local pen_path = "/pen"

    if vim.fn.filereadable(exclude_file) == 0 then
        return false
    end

    local file = io.open(exclude_file, "r")
    if file then
        for line in file:lines() do
            if line == pen_path then
                file:close()
                return true
            end
        end
        file:close()
    end

    return false
end

-- Fonction pour ajouter le dossier "pen" à .git/info/exclude
local function add_pen_to_exclude()
    local exclude_file = vim.fn.getcwd() .. "/.git/info/exclude"
    local pen_path = "/pen"

    local file = io.open(exclude_file, "a")
    if file then
        file:write(pen_path .. "\n")
        file:close()
    else
        print("Impossible d'ouvrir ou de créer le fichier .git/info/exclude")
    end
end

-- Mappage leader (leader n) pour exécuter les actions
vim.keymap.set("n", "<leader>m", function()
    if not check_git_folder() then
        print("Pas de projet Git détecté")
        return
    end
    if not is_pen_excluded() then
        add_pen_to_exclude()
    end
    ensure_pen_folder()
    open_notes_md()
end, { noremap = true, silent = true })

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
