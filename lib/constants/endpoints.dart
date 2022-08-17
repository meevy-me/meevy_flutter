const String baseUrl = 'https://souldate.herokuapp.com/';
const String callbackUrl = baseUrl + 'users/callback/';
const String spotifyMeEndpoint = "https://api.spotify.com/v1/me";
const String spotifyTokenEndpoint = "https://accounts.spotify.com/api/token";
const String spotifySearchEndpoint = "https://api.spotify.com/v1/search";
const String checkUserUrl = baseUrl + 'users/exists/';
const String loginUrl = baseUrl + 'users/login/';
const String registerUrl = baseUrl + 'users/register/';
const String profileUrl = baseUrl + 'users/profile/';
const String profileMeUrl = baseUrl + 'users/profile/me';
const String fetchDataUrl = baseUrl + 'spotify/fetch/';
const String defaultGirlUrl =
    "https://images.unsplash.com/photo-1600486913747-55e5470d6f40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fG1hbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60";
const String defaultArtistUrl =
    "https://media.gq-magazine.co.uk/photos/5ebd301ea7a089b1a9138c63/master/pass/20200514-Martin-Garrix-01.jpg";
const String fetchMatchesUrl = baseUrl + "spotify/match/";
const String fetchSpotsUrl = baseUrl + "socials/spots/";
const String fetchSpotsMeUrl = baseUrl + "socials/spots/me/";
const String fetchChatsUrl = baseUrl + "socials/chats/";
const String fetchFriendsUrl = baseUrl + "socials/friend/";
const String fetchFriendRequestsUrl = baseUrl + "socials/friend/requests/";
const String acceptRequestUrl = baseUrl + "socials/friend/accept/";
const String fetchMessagesUrl = baseUrl + "socials/fetch/messages/";
const String playerUrl = "https://api.spotify.com/v1/me/player";
const String queueUrl = "https://api.spotify.com/v1/me/player/queue";
const String spotsWs = 'ws://souldate.herokuapp.com/ws/spots/';
const String messagesWs = 'ws://souldate.herokuapp.com/ws/chats/';
const String requestUrl = baseUrl + 'socials/friend/request/';
const String uploadImageUrl = baseUrl + 'users/pictures/add/';
const String picturesUrl = baseUrl + 'users/pictures/';
const String resetPasswordUrl = baseUrl + 'users/password/reset/';
const String defaultAvatarUrl =
    "https://as1.ftcdn.net/v2/jpg/03/39/45/96/1000_F_339459697_XAFacNQmwnvJRqe1Fe9VOptPWMUxlZP8.jpg";
const String registerDeviceUrl = baseUrl + "users/firebase/register/";
const String myFavouriteUrl = baseUrl + "users/me/favourite/";
