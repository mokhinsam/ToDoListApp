# ToDoListApp 

ToDoListApp — это приложение, разработанное с использованием UIKit, которое демонстрирует навыки разработки мобильных приложений. Приложение позволяет пользователям посмотреть список задач, создать новую задачу и отредактировать уже существующую, удалить задачу. Есть поиск по задачам. Также задачу можно отметить как "выполнено/не выполнено". У каждой задачи отмечена дата создания. При первом запуске приложения данные из сети (json) сохраняются в базу данных CoreData, а после оттуда (из базы) берутся для отображения в интерфейсе. 


## 📌 Основные особенности
- Архитектура: **VIPER**
- Используемые технологии: 
   - **UIKit, Storyboards**
   - **GCD**
   - **Date, UIView.animate, Protocols, Singletones, Odserver, UIStoryboardSegue, Notification, NotificationCenter**
   - **Интерфейс: UITableView (UITableViewDelegate, UITableViewDataSource), UITableViewCell, UISearchBar (UISearchBarDelegate), Navigation, ScrollView, UITextView (UITextViewDelegate), UIButton, UILabel**
- Network: **URLSession, JSONDecoder, Result<Success, Failure>**
- База данных: **CoreData, UserDefaulrs (вспомогательно)**
- Тесты: XCTest


## 📋 Краткое описание основных функций приложения
- На первом экране отображается список задач:
     - Долгим нажатием на задачу можно вызвать Menu, в котором будет три раздела "Редактировать", "Поделиться", "Удалить".
     - Удаление задачи при нажатии "Удалить" в Menu.
     - Редактирование: при нажатии "Редактировать" в Menu или по нажатию на ячейку открывается второй экран, на котором можно внести изменения в задачу и сохранить.
     - Кнопка "выполнено/не выполнено": отмечает задачу как выполненную, меняется стиль ячейки.
     - Внизу экрана есть счетчик задач. При добавлении новых задач или удалении задачи счетчик меняется.
     - Кнопка добавляющая новые задачи переносит нас на второй экран, где можно создать и сохранить новую задачу.
     - Поиск по задачам (по заголовку и описанию одновременно) осуществляется по базе данных. Таблица подстаивается под поиск.
     - Клавиатура настроена так, чтобы не перекрывать задачи во время поиска. 
 
- На втором экране отображается дата создания новой/существующей задачи, два поля для заголовка и тела задачи:
     - В первом поле вводится заголовок задачи. На нее наведен курсор, когда мы создаем новую задачу. 
     - Во втором поле вводится описание задачи.
     - Дата генерируется автоматически и статична при добавлении новой задачи, а при работе с существующей задачей дата берется из CoreData.
     - Кнопка "Сохранить" появляется и изсчезает в зависимости от поведения пользователя.
     - Клавиатура и ScrollView настроены так, чтобьы не перекрывать поле с описанием задачи. 


## 🌳 Структура проекта
```bash
ToDoListApp/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Info.plist
├── ToDoList/
│   │   ├── ToDoCell/
│   │   │   ├── ToDoCell.swift
│   │   │   └── ToDoCellViewModel.swift    
│   ├── ToDoListViewController.swift
│   ├── ToDoListPresenter.swift
│   ├── ToDoListInteractor.swift
│   ├── ToDoListRouter.swift
│   └── ToDoListConfigurator.swift
├── ToDoDetails/
│   ├── ToDoDetailsViewController.swift
│   ├── ToDoDetailsPresenter.swift
│   ├── ToDoDetailsInteractor.swift
│   └── ToDoDetailsConfigurator.swift
├── Models/
│   └── Todos.swift
├── Services/
│   ├── NetworkManager.swift
│   └── StorageManager.swift
├── Extensions/
│   ├── Extension + String.swift
│   ├── Extension + Notification.Name.swift
│   └── Extension + UIViewController.swift
├── Storyboards/
│   ├── LaunchScreen.storyboard
│   └── Main.storyboard
├── Resources/
│  └── Assets.xcassets
├── ToDoListApp.xcdatamodeld
└── ToDoListAppTests/
   └── NetworkManagerTests.swift

```


## ⚙️ Установка
Для запуска приложения вам потребуется:
1. Установленный Xcode.
2. Клонировать репозиторий:

   ```bash
   git clone https://github.com/mokhinsam/ToDoListApp.git
    ```
3. Открыть проект в Xcode:
    ```bash
    cd ToDoListApp
    open ToDoListApp.xcodeproj
    ```
4. Запустить приложение на симуляторе или физическом устройстве.


## 📫 Контакты
Если у вас есть вопросы или предложения, вы можете связаться со мной по электронной почте: mokhinsam@gmail.com

