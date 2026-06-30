--[[

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⢻⠉⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⢀⣾⠗⠀⢸⡆⠀⠪⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⢻⡧⠀⠀⠀⠀⠀⣾⠣⠀⠀⠈⢿⠀⠀⠀⠿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠔⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡶⠋⠀⢸⣁⣤⣀⣀⣀⢸⡏⠀⠀⠀⠀⢸⡄⠀⠀⢽⣏⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣰⠇⠸⣷⣶⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣤⣤⣀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣶⠉⠀⠀⠀⠸⠉⠀⠈⠉⠉⠿⠿⣶⣶⣀⡀⠸⡇⠀⠀⠈⣿⡉⠿⠷⣶⣆⣀⡀⠀⠀⠀⠀⠀⢰⣿⡿⠀⠀⢿⣸⢀⣀⣶⡶⠿⠏⠉⠁⠀⣀⡶⠏⢹⣇⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠄⠀⠀⢿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣾⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠿⠶⠶⠾⠿⠶⠶⠶⠾⠿⣿⠛⠳⢦⣄⠄⠿⡚⣃⣤⠶⠟⠛⠉⠉⠀⠀⠀⠀⠀⣠⠞⠉⠀⠀⠀⣿⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠁⠀⠀⠀⠀⠙⠂⠀⠀⠀⠀⢀⣠⡤⣖⣯⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⡟⠞⠀⠀⠈⠳⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⠁⠀⠀⠀⠀⠀⢸⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣆⠀⠀⠀⠀⠀⠀⣀⣠⠴⠞⢯⣡⠿⠏⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣄⡤⠴⠶⠛⣿⠆⢀⣰⠟⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠃⠀⠀⠀⠀⠀⠀⠀⢸⠇
⠀⠀⠀⠀⠀⠀⠀⠀⣄⣄⡀⠈⠓⣂⣠⠤⠖⠋⠉⡀⣰⡾⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⣰⣟⣠⠞⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡹⠖⠋⠉⠀⠀⠀⢀⣴⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠟⠙⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠳⣄⠀⠀⠀⣠⡴⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣇⠀⠀⢺⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠺⢚⣿⠿⠀⠀⠀⠀⠀⠀⠀⣸⢧⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠲⣠⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⢀⡿⠀⠀
⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠈⣿⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠓⢬⣷⡀⠀⠀⠀⠀⠀⣼⠓⠀⠀
⠀⠀⠀⠀⠀⠀⣿⡖⢒⡶⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠿⣤⡀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⠃⠀⠀⢹⡇⠀⣿⠀⠀⠀⠀⢠⣶⠾⠛⠛⠿⢶⣥⡀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⢰⣏⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣀⡟⠺⣗⢤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⡀⠀⠀⠀⠀⠀⠙⠿⣷⣶⣶⣤⣤⣤⣤⣴⡀⠀⠀⠀⣏⣴⣆⡀⢸⣷⢘⣿⢠⠆⢠⡀⠁⠀⠀⠀⠀⠀⠐⠽⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠈⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠿⠏⠈⢶⡈⠹⢷⣆⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡉⠉⠉⠿⠿⠉⠀⠀⠀⠀⢿⣆⢈⡹⠿⠁⠰⣿⡿⢀⡏⢀⡆⠀⠀⠀⠀⠀⠀⠀⢹⣷⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⢦⣀⡉⠙⠓⠶⠦⣤⣄⣀⣀⠀⡀⠀⠀⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⢠⡏⢀⡶⠀⠀⠀⠀⠀⠀⠀⠙⢯⣵⣦⡀⢰⣿⡇⠞⠑⣾⣿⣷⠀⠀⠀⠀⠀⠀⢸⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⢲⡏⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠦⢤⣀⡀⠀⠀⢠⣾⣧⣄⠀⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠀⠙⠀⠼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡇⠻⣌⣿⠥⠀⠀⠘⠋⠁⠀⠀⠀⠀⠀⠀⣾⡏⠃⠀⠸⢤⡀⠀⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠒⠺⠥⣥⣸⣶⣿⣓⣠⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠣⠁⠙⠛⠃⠀⣰⠆⠠⡆⠀⣤⢀⡀⠀⣠⡿⠄⠀⠀⠀⠀⢻⡄⠀⢀⡟⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢿⣿⣟⠋⠁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⢀⡴⡋⠃⠀⠀⠀⠀⠀⡼⠁⣠⡝⠁⣸⢃⡞⠁⣼⡿⠁⠀⠀⠀⠀⠀⠘⣿⠠⠟⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⢀⣰⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣾⣟⣠⣤⡴⡶⢿⡉⠀⠀⠀⣤⠀⠀⠀⠘⠁⠀⠋⠁⠘⠃⠾⠁⣰⡏⠀⠀⠀⠀⠀⠀⠀⠀⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⣾⣯⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀⠀⣹⡌⠁⠀⠀⠀⣿⣯⡀⠀⠀⠀⠀⠀⠀⠀⡀⣀⣤⣦⣧⠀⠐⡷⢦⣤⣀⡀⢀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠃⣼⡆⠀⠀⠀⢠⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠘⣇⠀⣰⡏⠀⠀⠀⠀⠀⣭⡿⠁⠀⠀⠀⠀⠀⠀⠀⠛⠉⣴⡟⠁⠀⢀⡇⠀⠈⠙⢿⣻⠾⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠇⣰⠛⣷⠀⠀⣰⡟⠠⣷⣴⡆⠀⠀⠀⠀⠠⣿⠓⣻⣾⡏⠀⠀⠀⠀⢠⣟⣋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⡅⠀⠀⢀⣸⠃⢰⢿⡛⠉⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣴⠃⠀⢹⣇⣹⡿⠀⠀⠹⠿⠁⠀⠀⠘⠻⣴⣿⡞⢯⣼⡥⠚⠀⠀⠀⠀⠁⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣤⣀⣨⡿⣴⣈⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢹⠇⠀⠀⠘⢻⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠲⢿⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣠⣤⠤⠶⠚⠋⠁⠀⠛⠛⠳⢤⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠿⠿⢶⣶⠾⠿⠏⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣟⡙⠛⠲⢦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣤⣰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠇⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠋⠁⠀⠀⠀⠀⠀⠀⠉⠛⠲⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⡴⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠲⣄⠀⠀⠀⠀⠀⠠⣾⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣄⣠⡤⠴⠺⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠔⠀⠄⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠐⠢⠤⣀⣀⠀⠀⠀⠀⠀⠀⣻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠈⣀⣀⡀⠐⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

• Im a Furry
• Fuck Skidder
• Credit: Anari ( Polaris Owner )
]]--

---=== Load UI ===---
local Polaris = loadstring(game:HttpGet('https://getpolaris.vercel.app/api/library'))()

--[[
Polaris:CustomTheme({
    Name = 'Polaris:Planet',
    Main = Color3.fromRGB(20, 15, 25),
    Sidebar = Color3.fromRGB(28, 20, 35),
    Section = Color3.fromRGB(42, 30, 52),
    Text = Color3.fromRGB(255, 245, 240),
    SubText = Color3.fromRGB(195, 165, 200),
    Outline = Color3.fromRGB(115, 85, 135),
    Accent = Color3.fromRGB(255, 195, 210),
    AccentGrad = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 195)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 185, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(195, 160, 240)),
    },
    Transparency = 0.1,
    Hover = Color3.fromRGB(58, 40, 70),
    font = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    fontBold = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
})
]]

---=== Create Window ===---
local Window = Polaris:CreateWindow({
    Title = 'POLARIS',  -- Name hub
    Theme = 'Default',  -- Set "Default" theme
    ConfigsFile = 'Polaris UI',  -- Name for confíg file
    Icon = 'rbxassetid://79370113865112'  -- Hub icon
})

---=== Create Tab ===---
local HomeTab = Window:Tab('Home', 'rbxassetid://10888331510')

---=== Create Section ===---
local Section1 = HomeTab:Section({
    Name = 'Section 1',
    Type = 'Box',   -- Another type: "Box"
    Side = 'Left',  -- Another side: "Right"
    Callback = function(state)
        print('Status: ' .. tostring(state))
    end
})

---=== Create Toggle ===---
Section1:Toggle({
    Name = 'Toggle 1',
    Default = false,
    Keybind = Enum.KeyCode.E,    -- Set default keybind
    Callback = function(state)
        print(state)
    end
})

---=== Create Slider ===---
Section1:Slider({
    Name = 'Slider 1',
    Min = 0,   -- Min value
    Max = 100, -- Max value
    Default = 50,  -- Default value
    Increment = 1,
    Callback = function(value)
        print(value)
    end
})

--=== Create Dropdown ( Normal ) ===---
Section1:Dropdown({
    Name = 'Dropdown 1',
    Items = {'Item 1', 'Item 2', 'Item 3'},
    Default = 'Item 1',
    Callback = function(value)
        print(value)
    end
})

---=== Create Dropdown ( Multi ) ===---
Section1:Dropdown({
    Name = 'Dropdown 2',
    Items = {'Item 4', 'Item 5', 'Item 6', 'Item 7', 'Item 8'},
    Default = 'Item 4',
    Multi = true,  -- Set true for multi dropdown
    Search = true, -- Set true if you want search in dropdown
    Callback = function(value)
        print(value)
    end
})

---=== Create Textbox ===---
Section1:Textbox({
    Name = 'Textbox 1',
    Placeholder = 'Enter text here...',
    Default = 'OwO',  -- Set Default Text
    Callback = function(text)
        print(text)
    end
})

---=== Create Color Picker ===---
Section1:ColorPicker({
    Name = 'Color Picker 1',
    Default = Color3.fromRGB(255, 255, 255),  -- Set Default Color
    Callback = function(color)
        print(color)
    end
})

---=== Create Another Section ===---
local Section2 = HomeTab:Section({
    Name = 'Section 2',
    Type = 'Text',
    Side = 'Right'
})

---=== Create Paragraph ===---
Section2:Paragraph({
    Title = 'Title',
    Content = 'This is content for paragraph',
    -- Image = '' 
    -- ImageSize = 60
  })

---=== Create Button ===---
Section2:Button({
    Name = 'Button 1',
    Callback = function()
        print('Hello World')
    end
})

---=== Notification ===---
Section2:Button({
    Name = 'Show Notification',
    Callback = function()
        Polaris:Notify({
            Title = 'Title',
            Content = 'This is content for notification',
            -- Icon = '',  -- Set your icon if you want
            Duration = 5  -- Notification Duration ( second )
        })
    end
})
