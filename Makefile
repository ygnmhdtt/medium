new:
	@./scripts/gen new $(F)
	@echo "articles/$(F).md generated"

draft:
	@./scripts/gen draft $(F)
	@echo "drafts/$(F).md generated"
