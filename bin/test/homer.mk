HOMER_TARGET ?= src/dc/homer
HOMER_REPO ?= https://github.com/sipcapture/homer-docker/
HOMER_BRANCH ?= main
HOMER_DIR ?= all-in-one
HOMER_TMP_DIR ?= tmp/homer
HOMER_EXCLUDE ?= dummy-* grafana/plugins/k8spacket-nodegraphplugin-datasource # *.md

homer_up_dc: $(HOMER_TMP_DIR)
	(cd $(HOMER_TMP_DIR) && git pull)
	rsync -a --delete-after \
		$(addprefix --exclude=,$(HOMER_EXCLUDE)) \
		$(HOMER_TMP_DIR)/$(HOMER_DIR)/ \
		$(HOMER_TARGET)/

$(HOMER_TMP_DIR):
	mkdir -p $(HOMER_TARGET)
	git clone --depth 1 --filter=blob:none --no-checkout --branch $(HOMER_BRANCH) $(HOMER_REPO) $(HOMER_TMP_DIR)
	(cd $(HOMER_TMP_DIR) && git sparse-checkout set $(HOMER_DIR) && git checkout)

homer_rm_tmp:
	rm -rf $(HOMER_TMP_DIR)
