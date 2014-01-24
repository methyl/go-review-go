const API_HOST = 'http://localhost:3001';

var View = Backbone.View.extend({
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
  initialize: function (attributes, options) {
    this.url = options.url;
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
};

_.extend(GithubUrl.prototype, {
  isCommit: function () {
    return !! this.url.match(/^\/([^\/]+)\/([^\/]+)\/commit\//);
  }
});

$(function () {
  var url = new GithubUrl(window.location.pathname.toString());

  if (url.isCommit()) {
    var commit = new Commit({}, { url: location.pathname });
    var view = new View({ model: commit });
    view.render().$el.insertAfter($('.commit'));
    commit.fetch();
  }
});
