# Movie App

### Installation

1. Install dependencies:
    ```bash
    yarn
    ```

2. Install iOS dependencies:
    ```bash
    yarn pod
    ```

3. To run the app 
    ```bash
    yarn ios
    ```


### Setting Up the API

To make the app work, you need a valid [The Movie Database (TMDb)](https://www.themoviedb.org/) API key.

- **Step 1**: Obtain your API key [here](https://www.themoviedb.org/settings/api). You will need to register and log in to get access to the API.

- **Step 2**: After getting your API key, copy the `.env.example` file and rename it to `.env`.

- **Step 3**: Open the `.env` file and replace `TMDB_API_KEY` with your actual TMDb API key:
    ```
    TMDB_API_KEY=your_actual_api_key
    ```

