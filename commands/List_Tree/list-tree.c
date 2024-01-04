#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <stdbool.h>

void listFilesRecursively(const char *basePath, const char **excludeDirs, bool showHidden, int depth) {
    char path[1000];
    struct dirent *dp;
    DIR *dir = opendir(basePath);

    if (!dir) {
        perror("Erreur lors de l'ouverture du répertoire");
        return;
    }

    while ((dp = readdir(dir)) != NULL) {
        if (strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
            sprintf(path, "%s/%s", basePath, dp->d_name);

            // Vérifier si le dossier doit être exclu
            bool exclude = false;
            for (int i = 0; excludeDirs[i] != NULL; i++) {
                if (strcmp(dp->d_name, excludeDirs[i]) == 0) {
                    exclude = true;
                    break;
                }
            }

            if (!exclude && (showHidden || dp->d_name[0] != '.')) {
                // Afficher l'indentation
                for (int i = 0; i < depth; i++) {
                    printf("  ");
                }

                // Afficher le nom du fichier ou du dossier
                printf("%s", dp->d_name);

                if (dp->d_type == DT_DIR) {
                    // Si c'est un dossier, ajouter le séparateur "/"
                    printf("/");
                    // Appeler récursivement pour le dossier
                    listFilesRecursively(path, excludeDirs, showHidden, depth + 1);
                }

                printf("\n");
            }
        }
    }

    closedir(dir);
}

void printHelp() {
    printf("Usage: ./list_files [options] <directory_path>\n");
    printf("Options:\n");
    printf("  -e, --exclude <folder>    Exclude the specified subfolder (can be used multiple times)\n");
    printf("  -a, --all                 List all files and folders, including hidden ones\n");
    printf("  -h, --help                Display this help message\n");
}

int main(int argc, char *argv[]) {
    const char *basePath = NULL;
    const char **excludeDirs = NULL;
    bool showHidden = false;

    // Analyser les arguments de la ligne de commande
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-e") == 0 || strcmp(argv[i], "--exclude") == 0) {
            // Option d'exclusion
            if (i + 1 < argc) {
                excludeDirs = realloc(excludeDirs, (i + 3) * sizeof(char *));
                excludeDirs[i - 1] = argv[i + 1];
                excludeDirs[i] = NULL;
                i++; // Passer à l'argument suivant
            } else {
                fprintf(stderr, "Erreur: L'option --exclude nécessite un argument.\n");
                printHelp();
                return EXIT_FAILURE;
            }
        } else if (strcmp(argv[i], "-a") == 0 || strcmp(argv[i], "--all") == 0) {
            // Afficher les fichiers et dossiers cachés
            showHidden = true;
        } else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            // Afficher l'aide
            printHelp();
            return EXIT_SUCCESS;
        } else {
            // Chemin d'accès du dossier
            if (basePath == NULL) {
                basePath = argv[i];
            } else {
                fprintf(stderr, "Erreur: Argument inattendu '%s'. Utilisez l'option --help pour obtenir de l'aide.\n", argv[i]);
                return EXIT_FAILURE;
            }
        }
    }

    // Vérifier si un chemin d'accès a été fourni
    if (basePath == NULL) {
        fprintf(stderr, "Erreur: Veuillez spécifier un chemin d'accès au dossier. Utilisez l'option --help pour obtenir de l'aide.\n");
        return EXIT_FAILURE;
    }

    // Vérifier si l'option d'exclusion a été fournie
    if (excludeDirs == NULL) {
        excludeDirs = malloc(2 * sizeof(char *));
        excludeDirs[0] = NULL;
    }

    // Afficher l'arborescence du dossier
    listFilesRecursively(basePath, excludeDirs, showHidden, 0);

    // Libérer la mémoire allouée pour la liste des dossiers à exclure
    free(excludeDirs);

    return 0;
}
