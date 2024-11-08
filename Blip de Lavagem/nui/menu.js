document.addEventListener("DOMContentLoaded", () => {
    const menuContainer = document.querySelector(".menu-container");

    menuContainer.style.display = "none"; 

    // Fecha o menu ao pressionar ESC ou F6
    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape" || event.key === "F6") {
            closeMenu();
        }
    });

    // Função para abrir o menu
    window.addEventListener("message", (event) => {
        if (event.data.action === "open") {
            menuContainer.style.display = "flex"; // Exibe o menu
        } else if (event.data.action === "close") {
            menuContainer.style.display = "none"; // Oculta o menu
        }
    });

    // Função para fechar o menu
    function closeMenu() {
        menuContainer.style.display = "none"; // Oculta o menu
        fetch(`https://${GetParentResourceName()}/close`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({})
        });
    }

    window.lavarDinheiro = function() {
        const quantidade = parseInt(document.getElementById("quantidade").value);
        if (isNaN(quantidade) || quantidade <= 0) {
            alert("Insira uma quantidade válida.");
            return;
        }

        // Envia a quantidade para o servidor para processar a lavagem
        fetch(`https://${GetParentResourceName()}/lavarDinheiro`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ quantidade })
        })
        .then(response => response.json())
        .then(data => {
            console.log("Lavagem de dinheiro realizada:", data);
        })
        .catch(error => {
            console.error("Erro ao lavar o dinheiro:", error);
        });
    };
});