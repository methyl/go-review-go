const API_HOST = 'http://localhost:3001/';

var CommitView = Backbone.View.extend({
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  template: _.template(
    '<div class="code-review code-review-<%= status %>">' +
    '  <div class="buttons">' +
    '    <button class="button primary" data-status="accepted">Accept</button>' +
    '    <button class="button" data-status="passed">Pass</button>' +
    '    <button class="button danger" data-status="rejected">Reject</button>' +
    '  </div>' +
    '  <h2>Code review</h2>' +
    '</div>'
  ),

  events: {
    'click button[data-status]': function (e) {
      this.model.save({ status: $(e.currentTarget).data('status') });
    }
  }
});

var Commit = Backbone.Model.extend({
  url: function () {
    return '/commits/' + this.get('sha');
  },

  sync: function (method, model, options) {
    options.url = API_HOST + _.result(model, 'url');
    return Backbone.sync(method, model, options);
  },

  isNew: function () {
    return false;
  }
});

var GithubUrl = function (url) {
  this.url = url;
  this.parts = url.slice(1).split('/');
};

_.extend(GithubUrl.prototype, {
  isCommit: function () {
    return this.parts[2] === 'commit';
  },

  isCommitsList: function () {
    return this.parts[2] === 'commits';
  },

  getUser: function () {
    return this.parts[0];
  },

  getRepo: function () {
    return this.parts[1];
  },

  getCommitSha: function () {
    if (this.parts[2] !== 'commit') throw new Error("Cannot get commit SHA");
    return this.parts[3];
  }
});

$(function () {
  var url = new GithubUrl(window.location.pathname.toString());

  if (url.isCommit()) {
    var commit = new Commit({ sha: url.getCommitSha() });
    var view = new CommitView({ model: commit });
    view.render().$el.insertAfter($('.commit'));
    commit.fetch();
  }
});
