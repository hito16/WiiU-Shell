#ifndef WIIU_SHELL_CONFIG_H
#define WIIU_SHELL_CONFIG_H

#include <stdbool.h>

extern bool config_dark_theme;
extern int config_sort_by;

int Config_Save(bool config_dark_theme, int config_sort_by);
int Config_Load(void);

#endif