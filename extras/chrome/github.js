const API_HOST = 'http://localhost:3001/';

var FormView = Backbone.View.extend({
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  template: _.template(
    '<div class="code-review-form code-review code-review-<%= status %>">' +
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

var StatusView = Backbone.View.extend({
  initialize: function () {
    this.listenTo(this.model, "change", this.render);
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  template: _.template(
    '<div class="code-review-status code-review code-review-<%= status %>">' +
    '  <%= humanStatus %></h2>' +
    '</div>'
  )
});

var Commit = Backbone.Model.extend({
  defaults: {
    status: 'pending'
  },

  url: function () {
    return 'commits/' + this.get('sha');
  },

  sync: function (method, model, options) {
    options.url = API_HOST + _.result(model, 'url');
    return Backbone.sync(method, model, options);
  },

  isNew: function () {
    return false;
  },

  toJSON: function () {
    var json = Backbone.Model.prototype.toJSON.call(this);
    json.humanStatus = this.get('status').charAt(0).toUpperCase() + this.get('status').slice(1);
    return json;
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
    if (this.parts[2] !== 'commit' && this.parts[2] !== 'tree') throw new Error("Cannot get commit SHA");
    return this.parts[3];
  }
});

var App = function () {
  this.views = [];
};

_.extend(App.prototype, {
  run: function () {
    this.refresh();
  },

  refresh: function () {
    var url = window.location.pathname.toString();
    if (url != this.lastUrl) {
      this.lastUrl = url;
      this.remove();
      this.display();
    }
  },

  display: function () {
    var url = new GithubUrl(window.location.pathname.toString());

    if (url.isCommit()) {
      var commit = new Commit({ sha: url.getCommitSha() });
      var view = new FormView({ model: commit });
      view.render().$el.insertAfter($('.full-commit'));
      commit.fetch();
      this.views.push(view);
    } else if (url.isCommitsList()) {
      $('.commit-group .commit').each(function (i, el) {
        var el = $(el);
        var url = new GithubUrl(el.find('.browse-button').attr('href'));
        var commit = new Commit({ sha: url.getCommitSha() });
        var view = new StatusView({ model: commit });
        view.render().$el.appendTo(el.find('.commit-links'));
        commit.fetch();
        this.views.push(view);
      }.bind(this));
    }
  },

  remove: function () {
    this.views.forEach(function (view) {
      view.remove();
    });
    this.views = [];
    $('.code-review').remove();
  }
});

$(function () {
  var app = new App();
  app.run();

  chrome.runtime.onMessage.addListener(function (request) {
    if (request.message == 'history-updated') {
      window.setTimeout(function () {
        app.refresh();
      }, 500)
    }
  });
});
