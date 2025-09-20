function get_rank_title(_score) {
    if (_score < 250)  return "Intern";
    else if (_score < 500) return "Reporter";
    else if (_score < 1000) return "Staff Reporter";
    else if (_score < 1500) return "Correspondent";
    else if (_score < 2000) return "Columnist";
    else if (_score < 2500) return "Feature Writer";
    else if (_score < 3000) return "Copyeditor";
    else if (_score < 4000) return "Section Editor";
    else if (_score < 5000) return "Managing Editor";
    else return "Editor-in-Chief";
}
