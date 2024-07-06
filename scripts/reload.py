# Copyright (c) Anatoly Raev, 2024. All right reserved
#
# Unauthorized copying of any file in this repository, via any medium is strictly prohibited.
# All rights reserved by the Civil Code of the Russian Federation, Chapter 70.
# Proprietary and confidential.
# ------------
# Авторские права принадлежат Раеву Анатолию Анатольевичу.
#
# Копирование любого файла, через любой носитель абсолютно запрещено.
# Все авторские права защищены на основании ГК РФ Глава 70.
# Автор оставляет за собой право на защиту своих авторских прав согласно законам Российской Федерации.


from rcon.source import Client
from dotenv import load_dotenv
import os
load_dotenv()

with Client(os.getenv("RCON_IP"), int(os.getenv("RCON_PORT", 27015)), passwd=os.getenv("RCON_PASSWORD")) as client:
    client.run('metrostroi_ext_reload')
